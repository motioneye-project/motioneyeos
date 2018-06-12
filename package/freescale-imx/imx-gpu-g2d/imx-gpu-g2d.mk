################################################################################
#
# imx-gpu-g2d
#
################################################################################

IMX_GPU_G2D_VERSION = 6.2.4.p1.2
IMX_GPU_G2D_SITE = $(FREESCALE_IMX_SITE)
IMX_GPU_G2D_SOURCE = imx-gpu-g2d-$(IMX_GPU_G2D_VERSION).bin
IMX_GPU_G2D_DEPENDENCIES = imx-gpu-viv
IMX_GPU_G2D_INSTALL_STAGING = YES

IMX_GPU_G2D_LICENSE = NXP Semiconductor Software License Agreement
IMX_GPU_G2D_LICENSE_FILES = EULA COPYING
IMX_GPU_G2D_REDISTRIBUTE = NO

define IMX_GPU_G2D_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(IMX_GPU_G2D_DL_DIR)/$(IMX_GPU_G2D_SOURCE))
endef

define IMX_GPU_G2D_INSTALL_STAGING_CMDS
	cp -a $(@D)/g2d/usr/* $(STAGING_DIR)/usr
endef

ifeq ($(BR2_PACKAGE_IMX_GPU_G2D_EXAMPLES),y)
define IMX_GPU_G2D_INSTALL_EXAMPLES
	mkdir -p $(TARGET_DIR)/usr/share/examples/
	cp -a $(@D)/gpu-demos/opt/* $(TARGET_DIR)/usr/share/examples/
endef
endif

define IMX_GPU_G2D_INSTALL_TARGET_CMDS
	$(IMX_GPU_G2D_INSTALL_EXAMPLES)
	cp -a $(@D)/g2d/usr/lib $(TARGET_DIR)/usr
endef

$(eval $(generic-package))
