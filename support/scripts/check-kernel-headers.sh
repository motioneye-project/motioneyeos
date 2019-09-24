#!/bin/sh

BUILDDIR="${1}"
SYSROOT="${2}"
# Make sure we have enough version components
HDR_VER="${3}.0.0"

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

int main(int argc __attribute__((unused)),
         char** argv __attribute__((unused)))
{
    if((LINUX_VERSION_CODE & ~0xFF)
        != KERNEL_VERSION(${HDR_M},${HDR_m},0))
    {
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
