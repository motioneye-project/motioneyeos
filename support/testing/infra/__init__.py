import contextlib
import os
import re
import sys
import tempfile
import subprocess
from urllib2 import urlopen, HTTPError, URLError

ARTIFACTS_URL = "http://autobuild.buildroot.net/artefacts/"

@contextlib.contextmanager
def smart_open(filename=None):
    """
    Return a file-like object that can be written to using the 'with'
    keyword, as in the example:
    with infra.smart_open("test.log") as outfile:
       outfile.write("Hello, world!\n")
    """
    if filename and filename != '-':
        fhandle = open(filename, 'a+')
    else:
        fhandle = sys.stdout

    try:
        yield fhandle
    finally:
        if fhandle is not sys.stdout:
            fhandle.close()

def filepath(relpath):
    return os.path.join(os.getcwd(), "support/testing", relpath)

def download(dldir, filename):
    finalpath = os.path.join(dldir, filename)
    if os.path.exists(finalpath):
        return finalpath

    if not os.path.exists(dldir):
        os.makedirs(dldir)

    tmpfile = tempfile.mktemp(dir=dldir)
    print "Downloading to {}".format(tmpfile)

    try:
        url_fh = urlopen(os.path.join(ARTIFACTS_URL, filename))
        with open(tmpfile, "w+") as tmpfile_fh:
            tmpfile_fh.write(url_fh.read())
    except (HTTPError, URLError), err:
        os.unlink(tmpfile)
        raise err

    print "Renaming from %s to %s" % (tmpfile, finalpath)
    os.rename(tmpfile, finalpath)
    return finalpath

def get_elf_arch_tag(builddir, prefix, fpath, tag):
    """
    Runs the cross readelf on 'fpath', then extracts the value of tag 'tag'.
    Example:
    >>> get_elf_arch_tag('output', 'arm-none-linux-gnueabi-',
                         'bin/busybox', 'Tag_CPU_arch')
    v5TEJ
    >>>
    """
    cmd = ["host/usr/bin/{}-readelf".format(prefix),
           "-A", os.path.join("target", fpath)]
    out = subprocess.check_output(cmd, cwd=builddir, env={"LANG": "C"})
    regexp = re.compile("^  {}: (.*)$".format(tag))
    for line in out.splitlines():
        m = regexp.match(line)
        if not m:
            continue
        return m.group(1)
    return None

def get_file_arch(builddir, prefix, fpath):
    return get_elf_arch_tag(builddir, prefix, fpath, "Tag_CPU_arch")

def get_elf_prog_interpreter(builddir, prefix, fpath):
    cmd = ["host/usr/bin/{}-readelf".format(prefix),
           "-l", os.path.join("target", fpath)]
    out = subprocess.check_output(cmd, cwd=builddir, env={"LANG": "C"})
    regexp = re.compile("^ *\[Requesting program interpreter: (.*)\]$")
    for line in out.splitlines():
        m = regexp.match(line)
        if not m:
            continue
        return m.group(1)
    return None
