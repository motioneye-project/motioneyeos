################################################################################
#
# firmware-imx
#
################################################################################

FIRMWARE_IMX_VERSION = 5.4
FIRMWARE_IMX_SITE = $(FREESCALE_IMX_SITE)
FIRMWARE_IMX_SOURCE = firmware-imx-$(FIRMWARE_IMX_VERSION).bin

FIRMWARE_IMX_LICENSE = NXP Semiconductor Software License Agreement
FIRMWARE_IMX_LICENSE_FILES = EULA COPYING
FIRMWARE_IMX_REDISTRIBUTE = NO

FIRMWARE_IMX_BLOBS = sdma vpu

define FIRMWARE_IMX_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(FIRMWARE_IMX_SOURCE))
endef

define FIRMWARE_IMX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/imx
	for blobdir in $(FIRMWARE_IMX_BLOBS); do \
		cp -r $(@D)/firmware/$${blobdir} $(TARGET_DIR)/lib/firmware; \
	done
	cp -r $(@D)/firmware/epdc $(TARGET_DIR)/lib/firmware/imx
	mv $(TARGET_DIR)/lib/firmware/imx/epdc/epdc_ED060XH2C1.fw.nonrestricted \
		$(TARGET_DIR)/lib/firmware/imx/epdc/epdc_ED060XH2C1.fw
endef

$(eval $(generic-package))
