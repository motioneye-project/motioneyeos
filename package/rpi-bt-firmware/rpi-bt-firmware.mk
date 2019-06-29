################################################################################
#
# rpi-bt-firmware
#
################################################################################

RPI_BT_FIRMWARE_VERSION = 688531da4bcf802a814d9cb0c8b6d62e3b8a3327
RPI_BT_FIRMWARE_SITE = $(call github,LibreELEC,brcmfmac_sdio-firmware-rpi,$(RPI_BT_FIRMWARE_VERSION))
RPI_BT_FIRMWARE_LICENSE = PROPRIETARY
RPI_BT_FIRMWARE_LICENSE_FILES = LICENCE.broadcom_bcm43xx

define RPI_BT_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/brcm
	$(INSTALL) -m 0644 $(@D)/firmware/brcm/*.hcd $(TARGET_DIR)/lib/firmware/brcm
endef

$(eval $(generic-package))
