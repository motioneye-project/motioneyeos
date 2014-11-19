################################################################################
#
# libfslparser
#
################################################################################

LIBFSLPARSER_VERSION = 3.0.11
LIBFSLPARSER_SITE = $(FREESCALE_IMX_SITE)
LIBFSLPARSER_SOURCE = libfslparser-$(LIBFSLPARSER_VERSION).bin
LIBFSLPARSER_INSTALL_STAGING = YES

LIBFSLPARSER_LICENSE = Freescale Semiconductor Software License Agreement
LIBFSLPARSER_LICENSE_FILES = EULA EULA.txt
LIBFSLPARSER_REDISTRIBUTE = NO

define LIBFSLPARSER_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(DL_DIR)/$(LIBFSLPARSER_SOURCE))
endef

# The Makefile installs several versions of the libraries, but we only
# need one of them, depending on the platform.

# without AUTORECONF, configure fails to find install-sh.
LIBFSLPARSER_AUTORECONF = YES

$(eval $(autotools-package))
