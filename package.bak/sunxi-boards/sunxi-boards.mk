################################################################################
#
# sunxi-boards
#
################################################################################

SUNXI_BOARDS_VERSION = a6a4e94066f4ec6b26fc7060dc453a6bcf26a504
SUNXI_BOARDS_SITE = $(call github,linux-sunxi,sunxi-boards,$(SUNXI_BOARDS_VERSION))
SUNXI_BOARDS_DEPENDENCIES = host-sunxi-tools
SUNXI_BOARDS_INSTALL_IMAGES = YES
SUNXI_BOARDS_INSTALL_TARGET = NO
SUNXI_BOARDS_FEX_FILE = $(call qstrip,$(BR2_PACKAGE_SUNXI_BOARDS_FEX_FILE))

define SUNXI_BOARDS_INSTALL_IMAGES_CMDS
	$(FEX2BIN) $(@D)/sys_config/$(SUNXI_BOARDS_FEX_FILE) \
		$(BINARIES_DIR)/script.bin
endef

ifeq ($(BR2_PACKAGE_SUNXI_BOARDS)$(BR_BUILDING),yy)
# we NEED a board name
ifeq ($(SUNXI_BOARDS_FEX_FILE),)
$(error No sunxi .fex file specified. Check your BR2_PACKAGE_SUNXI_BOARDS_FEX_FILE settings)
endif
endif

$(eval $(generic-package))
