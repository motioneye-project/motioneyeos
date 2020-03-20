################################################################################
#
# imx-seco
#
################################################################################

IMX_SECO_VERSION = 2.3.1
IMX_SECO_SITE = $(FREESCALE_IMX_SITE)
IMX_SECO_SOURCE = imx-seco-$(IMX_SECO_VERSION).bin

IMX_SECO_LICENSE = NXP Semiconductor Software License Agreement
IMX_SECO_LICENSE_FILES = EULA COPYING
IMX_SECO_REDISTRIBUTE = NO

define IMX_SECO_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(IMX_SECO_DL_DIR)/$(IMX_SECO_SOURCE))
endef

IMX_SECO_INSTALL_IMAGES = YES

# SECO firmware is needed when generating imx8-boot-sd.bin which
# is done in post-image script.
ifeq ($(BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8X),y)
define IMX_SECO_INSTALL_IMAGES_CMDS
	cp $(@D)/firmware/seco/mx8qx-ahab-container.img \
		$(BINARIES_DIR)/ahab-container.img
endef
else ifeq ($(BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8),y)
define IMX_SECO_INSTALL_IMAGES_CMDS
	cp $(@D)/firmware/seco/mx8qm-ahab-container.img \
		$(BINARIES_DIR)/ahab-container.img
endef
endif

$(eval $(generic-package))
