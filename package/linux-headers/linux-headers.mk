################################################################################
#
# linux-headers
#
################################################################################

# This package is used to provide Linux kernel headers for the
# internal toolchain backend.

ifeq ($(BR2_KERNEL_HEADERS_AS_KERNEL),y)

LINUX_HEADERS_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))

# Compute LINUX_HEADERS_SOURCE and LINUX_HEADERS_SITE from the configuration
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_TARBALL),y)
LINUX_HEADERS_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
LINUX_HEADERS_SITE = $(patsubst %/,%,$(dir $(LINUX_HEADERS_TARBALL)))
LINUX_HEADERS_SOURCE = $(notdir $(LINUX_HEADERS_TARBALL))
BR_NO_CHECK_HASH_FOR += $(LINUX_HEADERS_SOURCE)
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_GIT),y)
LINUX_HEADERS_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_HEADERS_SITE_METHOD = git
# use same git tarball as linux kernel
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.gz
else ifeq ($(BR2_LINUX_KERNEL_CUSTOM_HG),y)
LINUX_HEADERS_SITE = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_HEADERS_SITE_METHOD = hg
# use same hg tarball as linux kernel
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.gz
else
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.xz
ifeq ($(BR2_LINUX_KERNEL_CUSTOM_VERSION),y)
BR_NO_CHECK_HASH_FOR += $(LINUX_HEADERS_SOURCE)
endif
# In X.Y.Z, get X and Y. We replace dots and dashes by spaces in order
# to use the $(word) function. We support versions such as 4.0, 3.1,
# 2.6.32, 2.6.32-rc1, 3.0-rc6, etc.
ifeq ($(findstring x2.6.,x$(LINUX_HEADERS_VERSION)),x2.6.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6
else ifeq ($(findstring x3.,x$(LINUX_HEADERS_VERSION)),x3.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v3.x
else ifeq ($(findstring x4.,x$(LINUX_HEADERS_VERSION)),x4.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v4.x
endif
# release candidates are in testing/ subdir
ifneq ($(findstring -rc,$(LINUX_HEADERS_VERSION)),)
LINUX_HEADERS_SITE := $(LINUX_HEADERS_SITE)/testing
endif # -rc
endif

LINUX_HEADERS_PATCHES = $(call qstrip,$(BR2_LINUX_KERNEL_PATCH))

# We rely on the generic package infrastructure to download and apply
# remote patches (downloaded from ftp, http or https). For local
# patches, we can't rely on that infrastructure, because there might
# be directories in the patch list (unlike for other packages).
LINUX_HEADERS_PATCH = $(filter ftp://% http://% https://%,$(LINUX_HEADERS_PATCHES))

define LINUX_HEADERS_APPLY_LOCAL_PATCHES
	for p in $(filter-out ftp://% http://% https://%,$(LINUX_HEADERS_PATCHES)) ; do \
		if test -d $$p ; then \
			$(APPLY_PATCHES) $(@D) $$p \*.patch || exit 1 ; \
		else \
			$(APPLY_PATCHES) $(@D) `dirname $$p` `basename $$p` || exit 1; \
		fi \
	done
endef

LINUX_HEADERS_POST_PATCH_HOOKS += LINUX_HEADERS_APPLY_LOCAL_PATCHES

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

endif # ! BR2_KERNEL_HEADERS_AS_KERNEL

LINUX_HEADERS_LICENSE = GPL-2.0
LINUX_HEADERS_LICENSE_FILES = COPYING

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
	(cd $(@D); \
		$(TARGET_MAKE_ENV) $(MAKE) \
			ARCH=$(KERNEL_ARCH) \
			HOSTCC="$(HOSTCC)" \
			HOSTCFLAGS="$(HOSTCFLAGS)" \
			HOSTCXX="$(HOSTCXX)" \
			INSTALL_HDR_PATH=$(@D)/usr \
			headers_install)
endef

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

ifeq ($(BR2_KERNEL_HEADERS_VERSION)$(BR2_KERNEL_HEADERS_AS_KERNEL),y)
define LINUX_HEADERS_CHECK_VERSION
	$(call check_kernel_headers_version,\
		$(STAGING_DIR),\
		$(call qstrip,$(BR2_TOOLCHAIN_HEADERS_AT_LEAST)))
endef
LINUX_HEADERS_POST_INSTALL_STAGING_HOOKS += LINUX_HEADERS_CHECK_VERSION
endif

$(eval $(generic-package))
