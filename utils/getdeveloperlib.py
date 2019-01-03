import os
import re
import glob
import subprocess

#
# Patch parsing functions
#

FIND_INFRA_IN_PATCH = re.compile("^\+\$\(eval \$\((host-)?([^-]*)-package\)\)$")


def analyze_patch(patch):
    """Parse one patch and return the list of files modified, added or
    removed by the patch."""
    files = set()
    infras = set()
    for line in patch:
        # If the patch is adding a package, find which infra it is
        m = FIND_INFRA_IN_PATCH.match(line)
        if m:
            infras.add(m.group(2))
        if not line.startswith("+++ "):
            continue
        line.strip()
        fname = line[line.find("/") + 1:].strip()
        if fname == "dev/null":
            continue
        files.add(fname)
    return (files, infras)


FIND_INFRA_IN_MK = re.compile("^\$\(eval \$\((host-)?([^-]*)-package\)\)$")


def fname_get_package_infra(fname):
    """Checks whether the file name passed as argument is a Buildroot .mk
    file describing a package, and find the infrastructure it's using."""
    if not fname.endswith(".mk"):
        return None

    if not os.path.exists(fname):
        return None

    with open(fname, "r") as f:
        for line in f:
            line = line.strip()
            m = FIND_INFRA_IN_MK.match(line)
            if m:
                return m.group(2)
    return None


def get_infras(files):
    """Search in the list of files for .mk files, and collect the package
    infrastructures used by those .mk files."""
    infras = set()
    for fname in files:
        infra = fname_get_package_infra(fname)
        if infra:
            infras.add(infra)
    return infras


def analyze_patches(patches):
    """Parse a list of patches and returns the list of files modified,
    added or removed by the patches, as well as the list of package
    infrastructures used by those patches (if any)"""
    allfiles = set()
    allinfras = set()
    for patch in patches:
        (files, infras) = analyze_patch(patch)
        allfiles = allfiles | files
        allinfras = allinfras | infras
    allinfras = allinfras | get_infras(allfiles)
    return (allfiles, allinfras)


#
# DEVELOPERS file parsing functions
#

class Developer:
    def __init__(self, name, files):
        self.name = name
        self.files = files
        self.packages = parse_developer_packages(files)
        self.architectures = parse_developer_architectures(files)
        self.infras = parse_developer_infras(files)

    def hasfile(self, f):
        f = os.path.abspath(f)
        for fs in self.files:
            if f.startswith(fs):
                return True
        return False


def parse_developer_packages(fnames):
    """Given a list of file patterns, travel through the Buildroot source
    tree to find which packages are implemented by those file
    patterns, and return a list of those packages."""
    packages = set()
    for fname in fnames:
        for root, dirs, files in os.walk(fname):
            for f in files:
                path = os.path.join(root, f)
                if fname_get_package_infra(path):
                    pkg = os.path.splitext(f)[0]
                    packages.add(pkg)
    return packages


def parse_arches_from_config_in(fname):
    """Given a path to an arch/Config.in.* file, parse it to get the list
    of BR2_ARCH values for this architecture."""
    arches = set()
    with open(fname, "r") as f:
        parsing_arches = False
        for line in f:
            line = line.strip()
            if line == "config BR2_ARCH":
                parsing_arches = True
                continue
            if parsing_arches:
                m = re.match("^\s*default \"([^\"]*)\".*", line)
                if m:
                    arches.add(m.group(1))
                else:
                    parsing_arches = False
    return arches


def parse_developer_architectures(fnames):
    """Given a list of file names, find the ones starting by
    'arch/Config.in.', and use that to determine the architecture a
    developer is working on."""
    arches = set()
    for fname in fnames:
        if not re.match("^.*/arch/Config\.in\..*$", fname):
            continue
        arches = arches | parse_arches_from_config_in(fname)
    return arches


def parse_developer_infras(fnames):
    infras = set()
    for fname in fnames:
        m = re.match("^package/pkg-([^.]*).mk$", fname)
        if m:
            infras.add(m.group(1))
    return infras


def parse_developers(basepath=None):
    """Parse the DEVELOPERS file and return a list of Developer objects."""
    developers = []
    linen = 0
    if basepath is None:
        basepath = os.getcwd()
    with open(os.path.join(basepath, "DEVELOPERS"), "r") as f:
        files = []
        name = None
        for line in f:
            line = line.strip()
            if line.startswith("#"):
                continue
            elif line.startswith("N:"):
                if name is not None or len(files) != 0:
                    print("Syntax error in DEVELOPERS file, line %d" % linen)
                name = line[2:].strip()
            elif line.startswith("F:"):
                fname = line[2:].strip()
                dev_files = glob.glob(os.path.join(basepath, fname))
                if len(dev_files) == 0:
                    print("WARNING: '%s' doesn't match any file" % fname)
                files += dev_files
            elif line == "":
                if not name:
                    continue
                developers.append(Developer(name, files))
                files = []
                name = None
            else:
                print("Syntax error in DEVELOPERS file, line %d: '%s'" % (linen, line))
                return None
            linen += 1
    # handle last developer
    if name is not None:
        developers.append(Developer(name, files))
    return developers


def check_developers(developers, basepath=None):
    """Look at the list of files versioned in Buildroot, and returns the
    list of files that are not handled by any developer"""
    if basepath is None:
        basepath = os.getcwd()
    cmd = ["git", "--git-dir", os.path.join(basepath, ".git"), "ls-files"]
    files = subprocess.check_output(cmd).strip().split("\n")
    unhandled_files = []
    for f in files:
        handled = False
        for d in developers:
            if d.hasfile(os.path.join(basepath, f)):
                handled = True
                break
        if not handled:
            unhandled_files.append(f)
    return unhandled_files
