################################################################################
#
# linux-headers
#
################################################################################

# This package is used to provide Linux kernel headers for the
# internal toolchain backend.

LINUX_HEADERS_VERSION = $(call qstrip,$(BR2_DEFAULT_KERNEL_HEADERS))
ifeq ($(findstring x2.6.,x$(LINUX_HEADERS_VERSION)),x2.6.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6/
else
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v3.x/
endif
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.xz

LINUX_HEADERS_INSTALL_STAGING = YES

# For some architectures (eg. Arc, Cris, Hexagon, ia64, parisc,
# score and xtensa), the Linux buildsystem tries to call the
# cross-compiler, although it is not needed at all.
# This results in seemingly errors like:
#   [...]/scripts/gcc-version.sh: line 26: arc-linux-uclibc-gcc: command not found
# Those can be safely ignored.
define LINUX_HEADERS_INSTALL_STAGING_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) $(MAKE) \
			ARCH=$(KERNEL_ARCH) \
			HOSTCC="$(HOSTCC)" \
			HOSTCFLAGS="$(HOSTCFLAGS)" \
			HOSTCXX="$(HOSTCXX)" \
			INSTALL_HDR_PATH=$(STAGING_DIR)/usr \
			headers_install)
endef

$(eval $(generic-package))
