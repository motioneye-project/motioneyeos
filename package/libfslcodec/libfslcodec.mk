################################################################################
#
# libfslcodec
#
################################################################################

LIBFSLCODEC_VERSION = 4.0.7
LIBFSLCODEC_SITE = $(FREESCALE_IMX_SITE)
LIBFSLCODEC_SOURCE = libfslcodec-$(LIBFSLCODEC_VERSION).bin
LIBFSLCODEC_INSTALL_STAGING = YES

LIBFSLCODEC_LICENSE = Freescale Semiconductor Software License Agreement, BSD-3c (flac, ogg headers)
LIBFSLCODEC_LICENSE_FILES = EULA COPYING
LIBFSLCODEC_REDISTRIBUTE = NO

define LIBFSLCODEC_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(LIBFSLCODEC_SOURCE))
endef

# FIXME The Makefile installs both the arm9 and arm11 versions of the
# libraries, but we only need one of them.

$(eval $(autotools-package))
