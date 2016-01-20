################################################################################
#
# linux-headers
#
################################################################################

# This package is used to provide Linux kernel headers for the
# internal toolchain backend.

ifeq ($(BR2_KERNEL_HEADERS_AS_KERNEL),y)

LINUX_HEADERS_VERSION = none
LINUX_HEADERS_SOURCE =

LINUX_HEADERS_LICENSE = $(LINUX_LICENSE)
LINUX_HEADERS_LICENSE_FILES = $(LINUX_LICENSE_FILES)

LINUX_HEADERS_PATCH_DEPENDENCIES = linux
LINUX_HEADERS_REAL_DIR = $(LINUX_DIR)

else # ! BR2_KERNEL_HEADERS_AS_KERNEL

LINUX_HEADERS_VERSION = $(call qstrip,$(BR2_DEFAULT_KERNEL_HEADERS))
ifeq ($(findstring x2.6.,x$(LINUX_HEADERS_VERSION)),x2.6.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6
else ifeq ($(findstring x3.,x$(LINUX_HEADERS_VERSION)),x3.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v3.x
else ifeq ($(findstring x4.,x$(LINUX_HEADERS_VERSION)),x4.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v4.x
endif
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.xz

LINUX_HEADERS_LICENSE = GPLv2
LINUX_HEADERS_LICENSE_FILES = COPYING

LINUX_HEADERS_REAL_DIR = $(@D)

endif # ! BR2_KERNEL_HEADERS_AS_KERNEL

LINUX_HEADERS_INSTALL_STAGING = YES

# linux-headers is part of the toolchain so disable the toolchain dependency
LINUX_HEADERS_ADD_TOOLCHAIN_DEPENDENCY = NO

# For some architectures (eg. Arc, Cris, Hexagon, ia64, parisc,
# score and xtensa), the Linux buildsystem tries to call the
# cross-compiler, although it is not needed at all.
# This results in seemingly errors like:
#   [...]/scripts/gcc-version.sh: line 26: arc-linux-uclibc-gcc: command not found
# Those can be safely ignored.

# This step is required to have a separate linux headers location for
# uClibc building. This way uClibc doesn't modify linux headers on installation
# of "its" headers
define LINUX_HEADERS_CONFIGURE_CMDS
	(cd $(LINUX_HEADERS_REAL_DIR); \
		$(TARGET_MAKE_ENV) $(MAKE) \
			ARCH=$(KERNEL_ARCH) \
			HOSTCC="$(HOSTCC)" \
			HOSTCFLAGS="$(HOSTCFLAGS)" \
			HOSTCXX="$(HOSTCXX)" \
			INSTALL_HDR_PATH=$(@D)/usr \
			headers_install)
endef

define LINUX_HEADERS_INSTALL_STAGING_CMDS
	(cd $(LINUX_HEADERS_REAL_DIR); \
		$(TARGET_MAKE_ENV) $(MAKE) \
			ARCH=$(KERNEL_ARCH) \
			HOSTCC="$(HOSTCC)" \
			HOSTCFLAGS="$(HOSTCFLAGS)" \
			HOSTCXX="$(HOSTCXX)" \
			INSTALL_HDR_PATH=$(STAGING_DIR)/usr \
			headers_install)
endef

ifeq ($(BR2_KERNEL_HEADERS_VERSION)$(BR2_KERNEL_HEADERS_AS_KERNEL),y)
define LINUX_HEADERS_CHECK_VERSION
	$(call check_kernel_headers_version,\
		$(STAGING_DIR),\
		$(call qstrip,$(BR2_TOOLCHAIN_HEADERS_AT_LEAST)))
endef
LINUX_HEADERS_POST_INSTALL_STAGING_HOOKS += LINUX_HEADERS_CHECK_VERSION
endif

$(eval $(generic-package))
