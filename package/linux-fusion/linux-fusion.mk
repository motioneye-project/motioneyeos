################################################################################
#
# linux-fusion
#
################################################################################

LINUX_FUSION_VERSION = 9.0.3
LINUX_FUSION_SITE = http://directfb.org/downloads/Core/linux-fusion
LINUX_FUSION_SOURCE = linux-fusion-$(LINUX_FUSION_VERSION).tar.xz
LINUX_FUSION_INSTALL_STAGING = YES
LINUX_FUSION_DEPENDENCIES = linux
LINUX_FUSION_LICENSE = GPL-2.0+
LINUX_FUSION_LICENSE_FILES = debian/copyright

LINUX_FUSION_ETC_DIR = $(TARGET_DIR)/etc/udev/rules.d

LINUX_FUSION_MAKE_OPTS = \
	KERNEL_VERSION=$(LINUX_VERSION_PROBED) \
	KERNEL_BUILD=$(LINUX_DIR) \
	KERNEL_SOURCE=$(LINUX_DIR) \
	SYSROOT=$(TARGET_DIR) \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	KERNEL_MODLIB=/lib/modules/$(LINUX_VERSION_PROBED)/kernel

define LINUX_FUSION_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(LINUX_FUSION_MAKE_OPTS) -C $(@D)
endef

define LINUX_FUSION_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(LINUX_FUSION_MAKE_OPTS) INSTALL_MOD_PATH=$(STAGING_DIR) -C $(@D) headers_install
endef

define LINUX_FUSION_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) \
		$(LINUX_FUSION_MAKE_OPTS) \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		-C $(@D) install
	$(INSTALL) -D -m 644 package/linux-fusion/40-fusion.rules \
		$(LINUX_FUSION_ETC_DIR)/40-fusion.rules
endef

$(eval $(generic-package))
