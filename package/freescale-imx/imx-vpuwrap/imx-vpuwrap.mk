################################################################################
#
# imx-vpuwrap
#
################################################################################

IMX_VPUWRAP_VERSION = 1.0.68
IMX_VPUWRAP_SITE = $(FREESCALE_IMX_SITE)
IMX_VPUWRAP_SOURCE = imx-vpuwrap-$(IMX_VPUWRAP_VERSION).bin
IMX_VPUWRAP_DEPENDENCIES = imx-vpu
IMX_VPUWRAP_INSTALL_STAGING = YES

IMX_VPUWRAP_LICENSE = NXP Semiconductor Software License Agreement
IMX_VPUWRAP_LICENSE_FILES = EULA COPYING
IMX_VPUWRAP_REDISTRIBUTE = NO

define IMX_VPUWRAP_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(IMX_VPUWRAP_SOURCE))
endef

$(eval $(autotools-package))
