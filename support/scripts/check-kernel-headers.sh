#!/bin/sh

# This script (and the embedded C code) will check that the actual
# headers version match the user told us they were:
#
# - if both versions are the same, all is well.
#
# - if the actual headers are older than the user told us, this is
#   an error.
#
# - if the actual headers are more recent than the user told us, and
#   we are doing a strict check, then this is an error.
#
# - if the actual headers are more recent than the user told us, and
#   we are doing a loose check, then a warning is printed, but this is
#   not an error.

BUILDDIR="${1}"
SYSROOT="${2}"
# Make sure we have enough version components
HDR_VER="${3}.0.0"
CHECK="${4}"  # 'strict' or 'loose'

HDR_M="${HDR_VER%%.*}"
HDR_V="${HDR_VER#*.}"
HDR_m="${HDR_V%%.*}"

# Exit on any error, so we don't try to run an unexisting program if the
# compilation fails.
set -e

# Set the clean-up trap in advance to prevent a race condition in which we
# create the file but get a SIGTERM before setting it. Notice that we don't
# need to care about EXEC being empty, since 'rm -f ""' does nothing.
trap 'rm -f "${EXEC}"' EXIT

EXEC="$(mktemp -p "${BUILDDIR}" -t .check-headers.XXXXXX)"

# We do not want to account for the patch-level, since headers are
# not supposed to change for different patchlevels, so we mask it out.
# This only applies to kernels >= 3.0, but those are the only one
# we actually care about; we treat all 2.6.x kernels equally.
${HOSTCC} -imacros "${SYSROOT}/usr/include/linux/version.h" \
          -x c -o "${EXEC}" - <<_EOF_
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc __attribute__((unused)),
         char** argv __attribute__((unused)))
{
    int l = LINUX_VERSION_CODE & ~0xFF;
    int h = KERNEL_VERSION(${HDR_M},${HDR_m},0);

    if ((l >= h) && !strcmp("${CHECK}", "loose"))
        return 0;

    if (l != h) {
        printf("Incorrect selection of kernel headers: ");
        printf("expected %d.%d.x, got %d.%d.x\n", ${HDR_M}, ${HDR_m},
               ((LINUX_VERSION_CODE>>16) & 0xFF),
               ((LINUX_VERSION_CODE>>8) & 0xFF));
        return 1;
    }
    return 0;
}
_EOF_

"${EXEC}"
