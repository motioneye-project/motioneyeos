################################################################################
#
# imx-sc-firmware
#
################################################################################

IMX_SC_FIRMWARE_VERSION = 1.0
IMX_SC_FIRMWARE_SITE = $(FREESCALE_IMX_SITE)
IMX_SC_FIRMWARE_SOURCE = imx-sc-firmware-$(IMX_SC_FIRMWARE_VERSION).bin

IMX_SC_FIRMWARE_LICENSE = NXP Semiconductor Software License Agreement
IMX_SC_FIRMWARE_LICENSE_FILES = EULA COPYING
IMX_SC_FIRMWARE_REDISTRIBUTE = NO

define IMX_SC_FIRMWARE_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(IMX_SC_FIRMWARE_DL_DIR)/$(IMX_SC_FIRMWARE_SOURCE))
endef

IMX_SC_FIRMWARE_INSTALL_IMAGES = YES
define IMX_SC_FIRMWARE_INSTALL_IMAGES_CMDS
	# SCFW firmware is needed when generating imx8-boot-sd.bin which
	# is done in post-image script.
	cp $(@D)/mx8qx-mek-scfw-tcm.bin $(BINARIES_DIR)/mx8qx-mek-scfw-tcm.bin
	cp $(@D)/mx8qx-val-scfw-tcm.bin $(BINARIES_DIR)/mx8qx-val-scfw-tcm.bin
endef

$(eval $(generic-package))
