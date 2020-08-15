# Copyright (C) 2010-2013 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
# Copyright (C) 2019 Yann E. MORIN <yann.morin.1998@free.fr>

import json
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

    deps = {}
    rdeps = defaultdict(list)
    types = {}
    versions = {}

    # Special case for the 'all' top-level fake package
    deps['all'] = []
    types['all'] = 'target'
    versions['all'] = ''

    cmd = ["make", "-s", "--no-print-directory", "show-info"]
    with open(os.devnull, 'wb') as devnull:
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=devnull,
                             universal_newlines=True)
        pkg_list = json.loads(p.communicate()[0])

    for pkg in pkg_list:
        deps['all'].append(pkg)
        types[pkg] = pkg_list[pkg]["type"]
        deps[pkg] = pkg_list[pkg].get("dependencies", [])
        for p in deps[pkg]:
            rdeps[p].append(pkg)
        versions[pkg] = \
            None if pkg_list[pkg]["type"] == "rootfs" \
            else "virtual" if pkg_list[pkg]["virtual"] \
            else pkg_list[pkg]["version"]

    return (deps, rdeps, types, versions)
