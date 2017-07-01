This directory contains various useful scripts and tools for working
with Buildroot. You need not add this directory in your PATH to use
any of those tools, but you may do so if you want.

check-package
    a script that checks the coding style of a package's Config.in and
    .mk files, and also tests them for various types of typoes.

get-developpers
    a script to return the list of people interested in a specific part
    of Buildroot, so they can be Cc:ed on a mail. Accepts a patch as
    input, a package name or and architecture name.

size-stat-compare
    a script to compare the rootfs size between two differnt Buildroot
    configurations. This can be used to identify the size impact of
    a specific option, or of a set of specific options, or an update
    to a newer Buildroot version...

test-pkg
    a script that tests a specific package against a set of various
    toolchains, with the goal to detect toolchain-related dependencies
    (wchar, threads...)
