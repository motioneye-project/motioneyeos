################################################################################
#
# x-loader
#
################################################################################

XLOADER_VERSION = 6f3a26101303051e0f91b6213735b68ce804e94e
XLOADER_SITE = git://gitorious.org/x-loader/x-loader.git
XLOADER_BOARD_NAME = $(call qstrip,$(BR2_TARGET_XLOADER_BOARDNAME))

XLOADER_LICENSE = GPLv2+
XLOADER_LICENSE_FILES = README

XLOADER_INSTALL_IMAGES = YES

define XLOADER_BUILD_CMDS
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D) $(XLOADER_BOARD_NAME)_config
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D) all
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D) ift
endef

define XLOADER_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0755 $(@D)/MLO $(BINARIES_DIR)/
endef

$(eval $(generic-package))

ifeq ($(BR2_TARGET_XLOADER),y)
# we NEED a board name unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(XLOADER_BOARD_NAME),)
$(error NO x-loader board name set. Check your BR2_BOOT_XLOADER_BOARDNAME setting)
endif
endif

endif
