################################################################################
#
# linux-headers
#
################################################################################

# This package is used to provide Linux kernel headers for the
# internal toolchain backend.

# Set variables depending on whether we are using headers from a kernel
# build or a standalone header package.
ifeq ($(BR2_KERNEL_HEADERS_AS_KERNEL),y)
LINUX_HEADERS_CUSTOM_TARBALL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL))
LINUX_HEADERS_CUSTOM_GIT = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_GIT))
LINUX_HEADERS_CUSTOM_HG = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_HG))
LINUX_HEADERS_CUSTOM_SVN = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_SVN))
LINUX_HEADERS_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_VERSION))
LINUX_HEADERS_CUSTOM_TARBALL_LOCATION = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION))
LINUX_HEADERS_REPO_URL = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_REPO_URL))
LINUX_HEADERS_CIP = $(BR2_LINUX_KERNEL_LATEST_CIP_VERSION)$(BR2_LINUX_KERNEL_LATEST_CIP_RT_VERSION)
else # ! BR2_KERNEL_HEADERS_AS_KERNEL
LINUX_HEADERS_CUSTOM_TARBALL = $(call qstrip,$(BR2_KERNEL_HEADERS_CUSTOM_TARBALL))
LINUX_HEADERS_CUSTOM_GIT = $(call qstrip,$(BR2_KERNEL_HEADERS_CUSTOM_GIT))
LINUX_HEADERS_CUSTOM_HG =
LINUX_HEADERS_CUSTOM_SVN =
LINUX_HEADERS_VERSION = $(call qstrip,$(BR2_DEFAULT_KERNEL_HEADERS))
LINUX_HEADERS_CUSTOM_TARBALL_LOCATION = $(call qstrip,$(BR2_KERNEL_HEADERS_CUSTOM_TARBALL_LOCATION))
LINUX_HEADERS_REPO_URL = $(call qstrip,$(BR2_KERNEL_HEADERS_CUSTOM_REPO_URL))
LINUX_HEADERS_CIP =
endif # BR2_KERNEL_HEADERS_AS_KERNEL

# Compute LINUX_HEADERS_SOURCE and LINUX_HEADERS_SITE from the configuration
ifeq ($(LINUX_HEADERS_CUSTOM_TARBALL),y)
LINUX_HEADERS_SOURCE = $(notdir $(LINUX_HEADERS_CUSTOM_TARBALL_LOCATION))
LINUX_HEADERS_SITE = $(patsubst %/,%,$(dir $(LINUX_HEADERS_CUSTOM_TARBALL_LOCATION)))
else ifeq ($(LINUX_HEADERS_CUSTOM_GIT),y)
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.gz
LINUX_HEADERS_SITE = $(LINUX_HEADERS_REPO_URL)
LINUX_HEADERS_SITE_METHOD = git
else ifeq ($(LINUX_HEADERS_CUSTOM_HG),y)
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.gz
LINUX_HEADERS_SITE = $(LINUX_HEADERS_REPO_URL)
LINUX_HEADERS_SITE_METHOD = hg
else ifeq ($(LINUX_HEADERS_CUSTOM_SVN),y)
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.gz
LINUX_HEADERS_SITE = $(LINUX_HEADERS_REPO_URL)
LINUX_HEADERS_SITE_METHOD = svn
else ifeq ($(LINUX_HEADERS_CIP),y)
LINUX_HEADERS_SOURCE = linux-cip-$(LINUX_HEADERS_VERSION).tar.gz
LINUX_HEADERS_SITE = https://git.kernel.org/pub/scm/linux/kernel/git/cip/linux-cip.git/snapshot
else ifneq ($(findstring -rc,$(LINUX_HEADERS_VERSION)),)
# Since 4.12-rc1, -rc kernels are generated from cgit. This also works for
# older -rc kernels.
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.gz
LINUX_HEADERS_SITE = https://git.kernel.org/torvalds/t
else
LINUX_HEADERS_SOURCE = linux-$(LINUX_HEADERS_VERSION).tar.xz
ifeq ($(findstring x2.6.,x$(LINUX_HEADERS_VERSION)),x2.6.)
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v2.6
else
LINUX_HEADERS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/v$(firstword $(subst ., ,$(LINUX_HEADERS_VERSION))).x
endif # x2.6
endif # LINUX_HEADERS_CUSTOM_TARBALL

# Apply any necessary patches if we are using the headers from a kernel
# build.
ifeq ($(BR2_KERNEL_HEADERS_AS_KERNEL),y)
LINUX_HEADERS_PATCHES = $(call qstrip,$(BR2_LINUX_KERNEL_PATCH)) \
	$(wildcard $(addsuffix /linux,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))))

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
endif # BR2_KERNEL_HEADERS_AS_KERNEL

# Skip hash checking for custom kernel headers.
ifeq ($(BR2_KERNEL_HEADERS_VERSION)$(BR2_KERNEL_HEADERS_CUSTOM_TARBALL)$(BR2_KERNEL_HEADERS_CUSTOM_GIT),y)
BR_NO_CHECK_HASH_FOR += $(LINUX_HEADERS_SOURCE)
endif

# linux-headers really is the same as the linux package
LINUX_HEADERS_DL_SUBDIR = linux

LINUX_HEADERS_LICENSE = GPL-2.0
ifeq ($(BR2_KERNEL_HEADERS_LATEST),y)
LINUX_HEADERS_LICENSE_FILES = \
	COPYING \
	LICENSES/preferred/GPL-2.0 \
	LICENSES/exceptions/Linux-syscall-note
endif

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

ifeq ($(BR2_KERNEL_HEADERS_VERSION)$(BR2_KERNEL_HEADERS_AS_KERNEL)$(BR2_KERNEL_HEADERS_CUSTOM_TARBALL)$(BR2_KERNEL_HEADERS_CUSTOM_GIT),y)
# In this case, we must always do a 'loose' test, because they are all
# custom versions which may be later than what we know right now.
define LINUX_HEADERS_CHECK_VERSION
	$(call check_kernel_headers_version,\
		$(BUILD_DIR),\
		$(STAGING_DIR),\
		$(call qstrip,$(BR2_TOOLCHAIN_HEADERS_AT_LEAST)),\
		loose)
endef
LINUX_HEADERS_POST_INSTALL_STAGING_HOOKS += LINUX_HEADERS_CHECK_VERSION
endif

$(eval $(generic-package))
