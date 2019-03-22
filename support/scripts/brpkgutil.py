# Copyright (C) 2010-2013 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
# Copyright (C) 2019 Yann E. MORIN <yann.morin.1998@free.fr>

import logging
import os
import subprocess
from collections import defaultdict


# This function returns a tuple of four dictionaries, all using package
# names as keys:
# - a dictionary which values are the lists of packages that are the
#   dependencies of the package used as key;
# - a dictionary which values are the lists of packages that are the
#   reverse dependencies of the package used as key;
# - a dictionary which values are the type of the package used as key;
# - a dictionary which values are the version of the package used as key,
#   'virtual' for a virtual package, or the empty string for a rootfs.
def get_dependency_tree():
    logging.info("Getting dependency tree...")

    deps = defaultdict(list)
    rdeps = defaultdict(list)
    types = {}
    versions = {}

    # Special case for the 'all' top-level fake package
    deps['all'] = []
    types['all'] = 'target'
    versions['all'] = ''

    cmd = ["make", "-s", "--no-print-directory", "show-dependency-tree"]
    with open(os.devnull, 'wb') as devnull:
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=devnull, universal_newlines=True)
        output = p.communicate()[0]

    for l in output.splitlines():
        if " -> " in l:
            pkg = l.split(" -> ")[0]
            deps[pkg] += l.split(" -> ")[1].split()
            for p in l.split(" -> ")[1].split():
                rdeps[p].append(pkg)
        else:
            pkg, type_version = l.split(": ", 1)
            t, v = "{} -".format(type_version).split(None, 2)[:2]
            deps['all'].append(pkg)
            types[pkg] = t
            versions[pkg] = v

    return (deps, rdeps, types, versions)
