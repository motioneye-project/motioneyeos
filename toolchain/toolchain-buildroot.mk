# Triggerring the build of the host-gcc-final will automaticaly do the
# build of binutils, uClibc, kernel headers and all the intermediate
# gcc steps.

include toolchain/helpers.mk

BUILDROOT_LIBC = $(call qstrip,$(BR2_TOOLCHAIN_BUILDROOT_LIBC))

toolchain-buildroot: host-gcc-final
