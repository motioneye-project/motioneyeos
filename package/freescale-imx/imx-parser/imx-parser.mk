################################################################################
#
# imx-parser
#
################################################################################

IMX_PARSER_VERSION = 4.2.1
IMX_PARSER_SITE = $(FREESCALE_IMX_SITE)
IMX_PARSER_SOURCE = imx-parser-$(IMX_PARSER_VERSION).bin
IMX_PARSER_INSTALL_STAGING = YES

IMX_PARSER_LICENSE = NXP Semiconductor Software License Agreement
IMX_PARSER_LICENSE_FILES = EULA COPYING
IMX_PARSER_REDISTRIBUTE = NO

ifeq ($(BR2_aarch64),y)
IMX_PARSER_CONF_OPTS += --enable-armv8
endif

ifeq ($(BR2_ARM_EABIHF),y)
IMX_PARSER_CONF_OPTS += --enable-fhw
else
IMX_PARSER_CONF_OPTS += --enable-fsw
endif

define IMX_PARSER_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(IMX_PARSER_SOURCE))
endef

# The Makefile installs several versions of the libraries, but we only
# need one of them, depending on the platform.

# Upstream installs libraries into usr/lib/imx-mm, but the dynamic
# loader only looks in usr/lib, so move the libraries there
define IMX_PARSER_FIXUP_TARGET_PATH
	find $(TARGET_DIR)/usr/lib/imx-mm -not -type d \
		-exec mv {} $(TARGET_DIR)/usr/lib \;
	rm -rf $(TARGET_DIR)/usr/lib/imx-mm
endef
IMX_PARSER_POST_INSTALL_TARGET_HOOKS += IMX_PARSER_FIXUP_TARGET_PATH

$(eval $(autotools-package))
