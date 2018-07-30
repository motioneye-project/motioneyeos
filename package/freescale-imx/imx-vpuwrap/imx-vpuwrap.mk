################################################################################
#
# imx-vpuwrap
#
################################################################################

IMX_VPUWRAP_VERSION = 4.3.5
IMX_VPUWRAP_SITE = $(FREESCALE_IMX_SITE)
IMX_VPUWRAP_SOURCE = imx-vpuwrap-$(IMX_VPUWRAP_VERSION).bin
IMX_VPUWRAP_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_IMX_VPU),y)
IMX_VPUWRAP_DEPENDENCIES = imx-vpu
endif

ifeq ($(BR2_PACKAGE_IMX_VPU_HANTRO),y)
IMX_VPUWRAP_DEPENDENCIES = imx-vpu-hantro
endif

IMX_VPUWRAP_LICENSE = NXP Semiconductor Software License Agreement
IMX_VPUWRAP_LICENSE_FILES = EULA COPYING
IMX_VPUWRAP_REDISTRIBUTE = NO

define IMX_VPUWRAP_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(IMX_VPUWRAP_DL_DIR)/$(IMX_VPUWRAP_SOURCE))
endef

$(eval $(autotools-package))
