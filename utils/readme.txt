This directory contains various useful scripts and tools for working
with Buildroot. You need not add this directory in your PATH to use
any of those tools, but you may do so if you want.

brmake
    a script that can be run instead of make, that prepends the date in
    front of each line, redirects all of the build output to a file
    ("'br.log' in the current directory), and just outputs the Buildroot
    messages (those lines starting with >>>) on stdout.
    Do not run this script for interactive configuration (e.g. menuconfig)
    or on an unconfigured directory. The output is redirected so you will see
    nothing.

check-package
    a script that checks the coding style of a package's Config.in and
    .mk files, and also tests them for various types of typoes.

get-developpers
    a script to return the list of people interested in a specific part
    of Buildroot, so they can be Cc:ed on a mail. Accepts a patch as
    input, a package name or and architecture name.

scancpan
    a script to create a Buildroot package by scanning a CPAN module
    description.

scanpypi
    a script to create a Buildroot package by scanning a PyPI package
    description.

size-stats-compare
    a script to compare the rootfs size between two different Buildroot
    configurations. This can be used to identify the size impact of
    a specific option, of a set of specific options, or of an update
    to a newer Buildroot version...

test-pkg
    a script that tests a specific package against a set of various
    toolchains, with the goal to detect toolchain-related dependencies
    (wchar, threads...)
