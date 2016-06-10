################################################################################
#
# imx-parser
#
################################################################################

IMX_PARSER_VERSION = 4.0.9
IMX_PARSER_SITE = $(FREESCALE_IMX_SITE)
IMX_PARSER_SOURCE = imx-parser-$(IMX_PARSER_VERSION).bin
IMX_PARSER_INSTALL_STAGING = YES

IMX_PARSER_LICENSE = NXP Semiconductor Software License Agreement
IMX_PARSER_LICENSE_FILES = EULA COPYING
IMX_PARSER_REDISTRIBUTE = NO

define IMX_PARSER_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(IMX_PARSER_SOURCE))
endef

# The Makefile installs several versions of the libraries, but we only
# need one of them, depending on the platform.

$(eval $(autotools-package))
