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
