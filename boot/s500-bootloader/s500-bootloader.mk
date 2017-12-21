################################################################################
#
# s500-bootloader
#
################################################################################

S500_BOOTLOADER_VERSION = a8d7fa1d9a7f353ec4613febf30f4ca99a10a106
S500_BOOTLOADER_SITE = $(call github,xapp-le,owl,$(S500_BOOTLOADER_VERSION))
S500_BOOTLOADER_LICENSE = PROPRIETARY
S500_BOOTLOADER_INSTALL_TARGET = NO
S500_BOOTLOADER_INSTALL_IMAGES = YES

S500_BOOTLOADER_BOARD = $(call qstrip,$(BR2_TARGET_S500_BOOTLOADER_BOARD))

define S500_BOOTLOADER_BUILD_CMDS
	cd $(@D) && ./tools/utils/bootloader_pack \
		s500/bootloader/bootloader.bin \
		s500/boards/$(S500_BOOTLOADER_BOARD)/bootloader.ini \
		s500-bootloader.bin
endef

define S500_BOOTLOADER_INSTALL_IMAGES_CMDS
	$(INSTALL) -m 0644 -D $(@D)/s500-bootloader.bin \
		$(BINARIES_DIR)/s500-bootloader.bin
endef

$(eval $(generic-package))

ifeq ($(BR2_TARGET_S500_BOOTLOADER)$(BR_BUILDING),yy)
# we NEED a board name
ifeq ($(S500_BOOTLOADER_BOARD),)
$(error No s500-bootloader board specified. Check your BR2_TARGET_S500_BOOTLOADER settings)
endif
endif
