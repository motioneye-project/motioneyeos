import os
import re
import sys
import tempfile
import subprocess
from urllib2 import urlopen, HTTPError, URLError

ARTIFACTS_URL = "http://autobuild.buildroot.net/artefacts/"


def open_log_file(builddir, stage, logtofile=True):
    """
    Open a file for logging and return its handler.
    If logtofile is True, returns sys.stdout. Otherwise opens a file
    with a suitable name in the build directory.
    """
    if logtofile:
        fhandle = open("{}-{}.log".format(builddir, stage), 'a+')
    else:
        fhandle = sys.stdout
    return fhandle


def filepath(relpath):
    return os.path.join(os.getcwd(), "support/testing", relpath)


def download(dldir, filename):
    finalpath = os.path.join(dldir, filename)
    if os.path.exists(finalpath):
        return finalpath

    if not os.path.exists(dldir):
        os.makedirs(dldir)

    tmpfile = tempfile.mktemp(dir=dldir)
    print("Downloading to {}".format(tmpfile))

    try:
        url_fh = urlopen(os.path.join(ARTIFACTS_URL, filename))
        with open(tmpfile, "w+") as tmpfile_fh:
            tmpfile_fh.write(url_fh.read())
    except (HTTPError, URLError) as err:
        os.unlink(tmpfile)
        raise err

    print("Renaming from {} to {}".format(tmpfile, finalpath))
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
    cmd = ["host/bin/{}-readelf".format(prefix),
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
    """
    Runs the cross readelf on 'fpath' to extract the program interpreter
    name and returns it.
    Example:
    >>> get_elf_prog_interpreter('br-tests/TestExternalToolchainLinaroArm',
                                 'arm-linux-gnueabihf',
                                 'bin/busybox')
    /lib/ld-linux-armhf.so.3
    >>>
    """
    cmd = ["host/bin/{}-readelf".format(prefix),
           "-l", os.path.join("target", fpath)]
    out = subprocess.check_output(cmd, cwd=builddir, env={"LANG": "C"})
    regexp = re.compile("^ *\[Requesting program interpreter: (.*)\]$")
    for line in out.splitlines():
        m = regexp.match(line)
        if not m:
            continue
        return m.group(1)
    return None
