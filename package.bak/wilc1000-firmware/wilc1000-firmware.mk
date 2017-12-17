################################################################################
#
# wilc1000-firmware
#
################################################################################

WILC1000_FIRMWARE_VERSION = 14.1
WILC1000_FIRMWARE_SITE = https://github.com/linux4sc/wireless-firmware/archive
WILC1000_FIRMWARE_SOURCE = v$(WILC1000_FIRMWARE_VERSION)_Firmware.zip

WILC1000_FIRMWARE_LICENSE = PROPRIETARY

define WILC1000_FIRMWARE_EXTRACT_CMDS
	$(UNZIP) -d $(BUILD_DIR) $(DL_DIR)/$(WILC1000_FIRMWARE_SOURCE)
	mv $(BUILD_DIR)/wireless-firmware-$(WILC1000_FIRMWARE_VERSION)_Firmware/* $(@D)
	rmdir $(BUILD_DIR)/wireless-firmware-$(WILC1000_FIRMWARE_VERSION)_Firmware
endef

define WILC1000_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/wilc1003_firmware.bin \
		$(TARGET_DIR)/lib/firmware/atmel/wilc1003_firmware.bin
endef

$(eval $(generic-package))
