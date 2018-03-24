################################################################################
#
# rpi-bt-firmware
#
################################################################################

RPI_BT_FIRMWARE_VERSION = 18d7c931aff0a8a78360b9b9eaeb15d1224fb907
RPI_BT_FIRMWARE_SITE = $(call github,LibreELEC,brcmfmac_sdio-firmware-rpi,$(RPI_BT_FIRMWARE_VERSION))
RPI_BT_FIRMWARE_LICENSE = PROPRIETARY
RPI_BT_FIRMWARE_LICENSE_FILES = LICENCE.broadcom_bcm43xx

RPI_BT_FIRMWARE_FILES = brcm/BCM43430A1.hcd BCM4345C0.hcd

define RPI_BT_FIRMWARE_INSTALL_TARGET_CMDS
	$(foreach file,$(RPI_BT_FIRMWARE_FILES),\
		$(INSTALL) -D -m 0644 $(@D)/firmware/$(file) $(TARGET_DIR)/lib/firmware/$(notdir $(file))
	)
endef

$(eval $(generic-package))
