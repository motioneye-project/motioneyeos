#!/bin/sh

CC="${1}"
# Make sure we have enough version components
HDR_VER="${2}.0.0"

HDR_M="${HDR_VER%%.*}"
HDR_V="${HDR_VER#*.}"
HDR_m="${HDR_V%%.*}"

# We do not want to account for the patch-level, since headers are
# not supposed to change for different patchlevels, so we mask it out.
# This only applies to kernels >= 3.0, but those are the only one
# we actually care about; we treat all 2.6.x kernels equally.

exec ${CC} -E -x c -o - - >/dev/null 2>&1 <<_EOF_
#include <linux/version.h>
#if (LINUX_VERSION_CODE & ~0xFF) != KERNEL_VERSION(${HDR_M},${HDR_m},0)
#error Incorrect kernel header version.
#endif
_EOF_
