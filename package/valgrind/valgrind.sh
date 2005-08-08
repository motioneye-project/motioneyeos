#!/bin/sh -e
#
# Valgrind wrapper

# Use special suppression file for uClibc
export VALGRIND_OPTS="$VALGRIND_OPTS --suppressions=/usr/lib/valgrind/uclibc.supp"

# Use 'exec' to avoid having another shell process hanging around.
exec $0.bin "$@"

