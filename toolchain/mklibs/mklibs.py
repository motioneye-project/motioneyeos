#! /usr/bin/python

# mklibs.py: An automated way to create a minimal /lib/ directory.
#
# Copyright 2001 by Falk Hueffner <falk@debian.org>
#                 & Goswin Brederlow <goswin.brederlow@student.uni-tuebingen.de>
#
# mklibs.sh by Marcus Brinkmann <Marcus.Brinkmann@ruhr-uni-bochum.de>
# used as template
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# HOW IT WORKS
#
# - Gather all unresolved symbols and libraries needed by the programs
#   and reduced libraries
# - Gather all symbols provided by the already reduced libraries
#   (none on the first pass)
# - If all symbols are provided we are done
# - go through all libraries and remember what symbols they provide
# - go through all unresolved/needed symbols and mark them as used
# - for each library:
#   - find pic file (if not present copy and strip the so)
#   - compile in only used symbols
#   - strip
# - back to the top

# TODO
# * complete argument parsing as given as comment in main

import commands
import string
import re
import sys
import os
import glob
import getopt
from stat import *

DEBUG_NORMAL  = 1
DEBUG_VERBOSE = 2
DEBUG_SPAM    = 3

debuglevel = DEBUG_NORMAL

def debug(level, *msg):
    if debuglevel >= level:
        print string.join(msg)

# A simple set class. It should be replaced with the standard sets.Set
# type as soon as Python 2.3 is out.
class Set:
    def __init__(self):
        self.__dict = {}

    def add(self, obj):
        self.__dict[obj] = 1

    def contains(self, obj):
        return self.__dict.has_key(obj)

    def merge(self, s):
        for e in s.elems():
            self.add(e)

    def elems(self):
        return self.__dict.keys()

    def size(self):
        return len(self.__dict)

    def __eq__(self, other):
        return self.__dict == other.__dict

    def __str__(self):
        return `self.__dict.keys()`

    def __repr__(self):
        return `self.__dict.keys()`

# return a list of lines of output of the command
def command(command, *args):
    debug(DEBUG_SPAM, "calling", command, string.join(args))
    (status, output) = commands.getstatusoutput(command + ' ' + string.join(args))
    if os.WEXITSTATUS(status) != 0:
        print "Command failed with status", os.WEXITSTATUS(status),  ":", \
               command, string.join(args)
	print "With output:", output
        sys.exit(1)
    return string.split(output, '\n')

# Filter a list according to a regexp containing a () group. Return
# a Set.
def regexpfilter(list, regexp, groupnr = 1):
    pattern = re.compile(regexp)
    result = Set()
    for x in list:
        match = pattern.match(x)
        if match:
            result.add(match.group(groupnr))

    return result

# Return a Set of rpath strings for the passed object
def rpath(obj):
    if not os.access(obj, os.F_OK):
        raise "Cannot find lib: " + obj
    output = command(target + "objdump", "--private-headers", obj)
    return map(lambda x: root + "/" + x, regexpfilter(output, ".*RPATH\s*(\S+)$").elems())

# Return a Set of libraries the passed objects depend on.
def library_depends(obj):
    if not os.access(obj, os.F_OK):
        raise "Cannot find lib: " + obj
    output = command(target + "objdump", "--private-headers", obj)
    return regexpfilter(output, ".*NEEDED\s*(\S+)$")

# Return a list of libraries the passed objects depend on. The
# libraries are in "-lfoo" format suitable for passing to gcc.
def library_depends_gcc_libnames(obj):
    if not os.access(obj, os.F_OK):
        raise "Cannot find lib: " + obj
    output = command(target + "objdump", "--private-headers", obj)
    output = regexpfilter(output, ".*NEEDED\s*lib(\S+)\.so.*$")
    if not output.elems():
        return ""
    else:
        return "-l" + string.join(output.elems(), " -l")

# Scan readelf output. Example:
# Num:    Value          Size Type    Bind   Vis      Ndx Name
#   1: 000000012002ab48   168 FUNC    GLOBAL DEFAULT  UND strchr@GLIBC_2.0 (2)
symline_regexp = \
    re.compile("\s*\d+: .+\s+\d+\s+\w+\s+(\w+)+\s+\w+\s+(\w+)\s+([^\s@]+)")

# Return undefined symbols in an object as a Set of tuples (name, weakness)
def undefined_symbols(obj):
    if not os.access(obj, os.F_OK):
        raise "Cannot find lib" + obj

    result = Set()
    output = command(target + "readelf", "-s", "-W", obj)
    for line in output:
        match = symline_regexp.match(line)
        if match:
            bind, ndx, name = match.groups()
            if ndx == "UND":
                result.add((name, bind == "WEAK"))
    return result

# Return a Set of symbols provided by a library
def provided_symbols(obj):
    if not os.access(obj, os.F_OK):
        raise "Cannot find lib" + obj

    result = Set()
    debug(DEBUG_SPAM, "provided_symbols result = ", `result`)
    output = command(target + "readelf", "-s", "-W", obj)
    for line in output:
        match = symline_regexp.match(line)
        if match:
            bind, ndx, name = match.groups()
            if bind != "LOCAL" and not ndx in ("UND", "ABS"):
                debug(DEBUG_SPAM, "provided_symbols adding ", `name`)
                result.add(name)
    return result

# Return real target of a symlink
def resolve_link(file):
    debug(DEBUG_SPAM, "resolving", file)
    while S_ISLNK(os.lstat(file)[ST_MODE]):
        new_file = os.readlink(file)
        if new_file[0] != "/":
            file = os.path.join(os.path.dirname(file), new_file)
        else:
            file = new_file
    debug(DEBUG_SPAM, "resolved to", file)
    return file

# Find complete path of a library, by searching in lib_path
def find_lib(lib):
    for path in lib_path:
        if os.access(path + "/" + lib, os.F_OK):
            return path + "/" + lib

    return ""

# Find a PIC archive for the library
def find_pic(lib):
    base_name = so_pattern.match(lib).group(1)
    for path in lib_path:
        for file in glob.glob(path + "/" + base_name + "_pic.a"):
            if os.access(file, os.F_OK):
                return resolve_link(file)
    return ""

# Find a PIC .map file for the library
def find_pic_map(lib):
    base_name = so_pattern.match(lib).group(1)
    for path in lib_path:
        for file in glob.glob(path + "/" + base_name + "_pic.map"):
            if os.access(file, os.F_OK):
                return resolve_link(file)
    return ""

def extract_soname(so_file):
    soname_data = regexpfilter(command(target + "readelf", "--all", "-W", so_file),
                               ".*SONAME.*\[(.*)\].*")
    if soname_data.elems():
        return soname_data.elems()[0]

    return ""
def usage(was_err):
    if was_err:
        outfd = sys.stderr
    else:
        outfd = sys.stdout
    print >> outfd, "Usage: mklibs [OPTION]... -d DEST FILE ..."
    print >> outfd, "Make a set of minimal libraries for FILE(s) in DEST."
    print >> outfd, ""
    print >> outfd, "  -d, --dest-dir DIRECTORY     create libraries in DIRECTORY"
    print >> outfd, "  -D, --no-default-lib         omit default libpath (", string.join(default_lib_path, " : "), ")"
    print >> outfd, "  -L DIRECTORY[:DIRECTORY]...  add DIRECTORY(s) to the library search path"
    print >> outfd, "      --ldlib LDLIB            use LDLIB for the dynamic linker"
    print >> outfd, "      --libc-extras-dir DIRECTORY  look for libc extra files in DIRECTORY"
    # Ugh... Adding the trailing '-' breaks common practice.
    #print >> outfd, "      --target TARGET          prepend TARGET- to the gcc and binutils calls"
    print >> outfd, "      --target TARGET          prepend TARGET to the gcc and binutils calls"
    print >> outfd, "      --root ROOT              search in ROOT for library rpaths"
    print >> outfd, "  -v, --verbose                explain what is being done"
    print >> outfd, "  -h, --help                   display this help and exit"
    sys.exit(was_err)

def version(vers):
    print "mklibs: version ",vers
    print ""

#################### main ####################
## Usage: ./mklibs.py [OPTION]... -d DEST FILE ...
## Make a set of minimal libraries for FILE ... in directory DEST.
##
## Options:
##   -L DIRECTORY               Add DIRECTORY to library search path.
##   -D, --no-default-lib       Do not use default lib directories of /lib:/usr/lib
##   -n, --dry-run              Don't actually run any commands; just print them.
##   -v, --verbose              Print additional progress information.
##   -V, --version              Print the version number and exit.
##   -h, --help                 Print this help and exit.
##   --ldlib                    Name of dynamic linker (overwrites environment variable ldlib)
##   --libc-extras-dir          Directory for libc extra files
##   --target                   Use as prefix for gcc or binutils calls
##
##   -d, --dest-dir DIRECTORY   Create libraries in DIRECTORY.
##
## Required arguments for long options are also mandatory for the short options.

# Clean the environment
vers="0.12 with uClibc fixes"
os.environ['LC_ALL'] = "C"

# Argument parsing
opts = "L:DnvVhd:r:"
longopts = ["no-default-lib", "dry-run", "verbose", "version", "help",
            "dest-dir=", "ldlib=", "libc-extras-dir=", "target=", "root="]

# some global variables
lib_rpath = []
lib_path = []
dest_path = "DEST"
ldlib = "LDLIB"
include_default_lib_path = "yes"
default_lib_path = ["/lib/", "/usr/lib/", "/usr/X11R6/lib/"]
libc_extras_dir = "/usr/lib/libc_pic"
target = ""
root = ""
so_pattern = re.compile("((lib|ld).*)\.so(\..+)*")
script_pattern = re.compile("^#!\s*/")

try:
    optlist, proglist = getopt.getopt(sys.argv[1:], opts, longopts)
except getopt.GetoptError, msg:
    print >> sys.stderr, msg
    usage(1)

for opt, arg in optlist:
    if opt in ("-v", "--verbose"):
        if debuglevel < DEBUG_SPAM:
            debuglevel = debuglevel + 1
    elif opt == "-L":
        lib_path.extend(string.split(arg, ":"))
    elif opt in ("-d", "--dest-dir"):
        dest_path = arg
    elif opt in ("-D", "--no-default-lib"):
        include_default_lib_path = "no"
    elif opt == "--ldlib":
        ldlib = arg
    elif opt == "--libc-extras-dir":
        libc_extras_dir = arg
    elif opt == "--target":
        #target = arg + "-"
        target = arg
    elif opt in ("-r", "--root"):
        root = arg
    elif opt in ("--help", "-h"):
	usage(0)
        sys.exit(0)
    elif opt in ("--version", "-V"):
        version(vers)
        sys.exit(0)
    else:
        print "WARNING: unknown option: " + opt + "\targ: " + arg

if include_default_lib_path == "yes":
    lib_path.extend(default_lib_path)

if ldlib == "LDLIB":
    ldlib = os.getenv("ldlib")

objects = {}  # map from inode to filename
for prog in proglist:
    inode = os.stat(prog)[ST_INO]
    if objects.has_key(inode):
        debug(DEBUG_SPAM, prog, "is a hardlink to", objects[inode])
    elif so_pattern.match(prog):
        debug(DEBUG_SPAM, prog, "is a library")
    elif script_pattern.match(open(prog).read(256)):
        debug(DEBUG_SPAM, prog, "is a script")
    else:
        objects[inode] = prog

if not ldlib:
    pattern = re.compile(".*Requesting program interpreter:.*/([^\]/]+).*")
    for obj in objects.values():
        output = command(target + "readelf", "--program-headers", obj)
	for x in output:
	    match = pattern.match(x)
	    if match:
	        ldlib = match.group(1)
	        break
	if ldlib:
	    break

if not ldlib:
    sys.exit("E: Dynamic linker not found, aborting.")

debug(DEBUG_NORMAL, "I: Using", ldlib, "as dynamic linker.")

pattern = re.compile(".*ld-uClibc.*");
if pattern.match(ldlib):
    uclibc = 1
else:
    uclibc = 0

# Check for rpaths
for obj in objects.values():
    rpath_val = rpath(obj)
    if rpath_val:
        if root:
            if debuglevel >= DEBUG_VERBOSE:
                print "Adding rpath " + string.join(rpath_val, ":") + " for " + obj
            lib_rpath.extend(rpath_val)
        else:
            print "warning: " + obj + " may need rpath, but --root not specified"

lib_path.extend(lib_rpath)

passnr = 1
previous_pass_unresolved = Set()
while 1:
    debug(DEBUG_NORMAL, "I: library reduction pass", `passnr`)
    if debuglevel >= DEBUG_VERBOSE:
        print "Objects:",
        for obj in objects.values():
            print obj[string.rfind(obj, '/') + 1:],
        print

    passnr = passnr + 1
    # Gather all already reduced libraries and treat them as objects as well
    small_libs = []
    for lib in regexpfilter(os.listdir(dest_path), "(.*-so-stripped)$").elems():
        obj = dest_path + "/" + lib
        small_libs.append(obj)
        inode = os.stat(obj)[ST_INO]
        if objects.has_key(inode):
            debug(DEBUG_SPAM, obj, "is hardlink to", objects[inode])
        else:
            objects[inode] = obj

    # DEBUG
    for obj in objects.values():
        small_libs.append(obj)
        debug(DEBUG_VERBOSE, "Object:", obj)

    # calculate what symbols and libraries are needed
    needed_symbols = Set()              # Set of (name, weakness-flag)
    libraries = Set()
    for obj in objects.values():
        needed_symbols.merge(undefined_symbols(obj))
        libraries.merge(library_depends(obj))

    # FIXME: on i386 this is undefined but not marked UND
    # I don't know how to detect those symbols but this seems
    # to be the only one and including it on alpha as well
    # doesn't hurt. I guess all archs can live with this.
    needed_symbols.add(("sys_siglist", 1))

    # calculate what symbols are present in small_libs
    present_symbols = Set()
    for lib in small_libs:
        present_symbols.merge(provided_symbols(lib))

    # are we finished?
    using_ctor_dtor = 0
    num_unresolved = 0
    present_symbols_elems = present_symbols.elems()
    unresolved = Set()
    for (symbol, is_weak) in needed_symbols.elems():
        if not symbol in present_symbols_elems:
            debug(DEBUG_SPAM, "Still need:", symbol, `is_weak`)
            unresolved.add((symbol, is_weak))
            num_unresolved = num_unresolved + 1

    debug (DEBUG_NORMAL, `needed_symbols.size()`, "symbols,",
           `num_unresolved`, "unresolved")

    if num_unresolved == 0:
        break

    if unresolved == previous_pass_unresolved:
        # No progress in last pass. Verify all remaining symbols are weak.
        for (symbol, is_weak) in unresolved.elems():
            if not is_weak:
                raise "Unresolvable symbol " + symbol
        break

    previous_pass_unresolved = unresolved

    library_symbols = {}
    library_symbols_used = {}
    symbol_provider = {}

    # Calculate all symbols each library provides
    for library in libraries.elems():
        path = find_lib(library)
        if not path:
            sys.exit("Library not found: " + library + " in path: "
                     + string.join(lib_path, " : "))
        symbols = provided_symbols(path)
        library_symbols[library] = Set()
        library_symbols_used[library] = Set()
        for symbol in symbols.elems():
            if symbol_provider.has_key(symbol):
                # in doubt, prefer symbols from libc
                if re.match("^libc[\.-]", library):
                    library_symbols[library].add(symbol)
                    symbol_provider[symbol] = library
                else:
                    debug(DEBUG_SPAM, "duplicate symbol", symbol, "in",
                          symbol_provider[symbol], "and", library)
            else:
                library_symbols[library].add(symbol)
                symbol_provider[symbol] = library

	# Fixup support for constructors and destructors
	if symbol_provider.has_key("_init"):
	    debug(DEBUG_VERBOSE, library, ": Library has a constructor!");
	    using_ctor_dtor = 1
	    library_symbols[library].add("_init")
	    symbol_provider["_init"] = library
            library_symbols_used[library].add("_init")

	if symbol_provider.has_key("_fini"):
	    debug(DEBUG_VERBOSE, library, ": Library has a destructor!");
	    using_ctor_dtor = 1
	    library_symbols[library].add("_fini")
	    symbol_provider["_fini"] = library
            library_symbols_used[library].add("_fini")

    # which symbols are actually used from each lib
    for (symbol, is_weak) in needed_symbols.elems():
        if not symbol_provider.has_key(symbol):
            if not is_weak:
                if not uclibc or (symbol != "main"):
                    raise "No library provides non-weak " + symbol
        else:
            lib = symbol_provider[symbol]
            library_symbols_used[lib].add(symbol)

    # reduce libraries
    for library in libraries.elems():
        debug(DEBUG_VERBOSE, "reducing", library)
        debug(DEBUG_SPAM, "using: " + string.join(library_symbols_used[library].elems()))
        so_file = find_lib(library)
        if root and (re.compile("^" + root).search(so_file)):
            debug(DEBUG_VERBOSE, "no action required for " + so_file)
            continue
        so_file_name = os.path.basename(so_file)
        if not so_file:
            sys.exit("File not found:" + library)
        pic_file = find_pic(library)
        if not pic_file:
            # No pic file, so we have to use the .so file, no reduction
            debug(DEBUG_VERBOSE, "No pic file found for", so_file, "; copying")
            command(target + "objcopy", "--strip-unneeded -R .note -R .comment",
                    so_file, dest_path + "/" + so_file_name + "-so-stripped")
        else:
            # we have a pic file, recompile
            debug(DEBUG_SPAM, "extracting from:", pic_file, "so_file:", so_file)
            soname = extract_soname(so_file)
            if soname == "":
                debug(DEBUG_VERBOSE, so_file, " has no soname, copying")
                continue
            debug(DEBUG_SPAM, "soname:", soname)
            base_name = so_pattern.match(library).group(1)
            # libc needs its soinit.o and sofini.o as well as the pic
            if (base_name == "libc") and not uclibc:
                # force dso_handle.os to be included, otherwise reduced libc
                # may segfault in ptmalloc_init due to undefined weak reference
                extra_flags = find_lib(ldlib) + " -u __dso_handle"
                extra_pre_obj = libc_extras_dir + "/soinit.o"
                extra_post_obj = libc_extras_dir + "/sofini.o"
            else:
                extra_flags = ""
                extra_pre_obj = ""
                extra_post_obj = ""
            map_file = find_pic_map(library)
            if map_file:
                extra_flags = extra_flags + " -Wl,--version-script=" + map_file
            if library_symbols_used[library].elems():
                joined_symbols = "-u" + string.join(library_symbols_used[library].elems(), " -u")
            else:
                joined_symbols = ""
	    if using_ctor_dtor == 1:
                extra_flags = extra_flags + " -shared"
            # compile in only used symbols
            command(target + "gcc",
                "-nostdlib -nostartfiles -shared -Wl,-soname=" + soname,\
                joined_symbols, \
                "-o", dest_path + "/" + so_file_name + "-so", \
                extra_pre_obj, \
                pic_file, \
                extra_post_obj, \
                extra_flags, \
                "-lgcc -L", dest_path, \
                "-L" + string.join(lib_path, " -L"), \
                library_depends_gcc_libnames(so_file))
            # strip result
            command(target + "objcopy", "--strip-unneeded -R .note -R .comment",
                      dest_path + "/" + so_file_name + "-so",
                      dest_path + "/" + so_file_name + "-so-stripped")
            ## DEBUG
            debug(DEBUG_VERBOSE, so_file, "\t", `os.stat(so_file)[ST_SIZE]`)
            debug(DEBUG_VERBOSE, dest_path + "/" + so_file_name + "-so", "\t",
                  `os.stat(dest_path + "/" + so_file_name + "-so")[ST_SIZE]`)
            debug(DEBUG_VERBOSE, dest_path + "/" + so_file_name + "-so-stripped",
                  "\t", `os.stat(dest_path + "/" + so_file_name + "-so-stripped")[ST_SIZE]`)

# Finalising libs and cleaning up
for lib in regexpfilter(os.listdir(dest_path), "(.*)-so-stripped$").elems():
    os.rename(dest_path + "/" + lib + "-so-stripped", dest_path + "/" + lib)
for lib in regexpfilter(os.listdir(dest_path), "(.*-so)$").elems():
    os.remove(dest_path + "/" + lib)

# Canonicalize library names.
for lib in regexpfilter(os.listdir(dest_path), "(.*so[.\d]*)$").elems():
    this_lib_path = dest_path + "/" + lib
    if os.path.islink(this_lib_path):
        debug(DEBUG_VERBOSE, "Unlinking %s." % lib)
        os.remove(this_lib_path)
        continue
    soname = extract_soname(this_lib_path)
    if soname:
        debug(DEBUG_VERBOSE, "Moving %s to %s." % (lib, soname))
        os.rename(dest_path + "/" + lib, dest_path + "/" + soname)

# Make sure the dynamic linker is present and is executable
ld_file = find_lib(ldlib)
ld_file_name = os.path.basename(ld_file)

if not os.access(dest_path + "/" + ld_file_name, os.F_OK):
    debug(DEBUG_NORMAL, "I: stripping and copying dynamic linker.")
    command(target + "objcopy", "--strip-unneeded -R .note -R .comment",
            ld_file, dest_path + "/" + ld_file_name)

os.chmod(dest_path + "/" + ld_file_name, 0755)
