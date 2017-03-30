################################################################################
#
# imx-codec
#
################################################################################

IMX_CODEC_VERSION = 4.1.4
IMX_CODEC_SITE = $(FREESCALE_IMX_SITE)
IMX_CODEC_SOURCE = imx-codec-$(IMX_CODEC_VERSION).bin
IMX_CODEC_INSTALL_STAGING = YES

IMX_CODEC_LICENSE = NXP Semiconductor Software License Agreement, BSD-3-Clause (flac, ogg headers)
IMX_CODEC_LICENSE_FILES = EULA COPYING
IMX_CODEC_REDISTRIBUTE = NO

ifeq ($(BR2_ARM_EABIHF),y)
IMX_CODEC_CONF_OPTS += --enable-fhw
endif

ifeq ($(BR2_PACKAGE_IMX_VPU),y)
IMX_CODEC_CONF_OPTS += --enable-vpu
endif

define IMX_CODEC_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(IMX_CODEC_SOURCE))
endef

# FIXME The Makefile installs both the arm9 and arm11 versions of the
# libraries, but we only need one of them.

# Upstream installs libraries into usr/lib/imx-mm, but the dynamic
# loader only looks in usr/lib, so move the libraries there
define IMX_CODEC_FIXUP_TARGET_PATH
	find $(TARGET_DIR)/usr/lib/imx-mm -not -type d \
		-exec mv {} $(TARGET_DIR)/usr/lib \;
	rm -rf $(TARGET_DIR)/usr/lib/imx-mm
endef
IMX_CODEC_POST_INSTALL_TARGET_HOOKS += IMX_CODEC_FIXUP_TARGET_PATH

$(eval $(autotools-package))
