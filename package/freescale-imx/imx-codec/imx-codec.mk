################################################################################
#
# imx-codec
#
################################################################################

IMX_CODEC_VERSION = 4.0.9
IMX_CODEC_SITE = $(FREESCALE_IMX_SITE)
IMX_CODEC_SOURCE = imx-codec-$(IMX_CODEC_VERSION).bin
IMX_CODEC_INSTALL_STAGING = YES

IMX_CODEC_LICENSE = NXP Semiconductor Software License Agreement, BSD-3c (flac, ogg headers)
IMX_CODEC_LICENSE_FILES = EULA COPYING
IMX_CODEC_REDISTRIBUTE = NO

define IMX_CODEC_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(IMX_CODEC_SOURCE))
endef

# FIXME The Makefile installs both the arm9 and arm11 versions of the
# libraries, but we only need one of them.

$(eval $(autotools-package))
