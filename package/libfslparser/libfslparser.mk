################################################################################
#
# libfslparser
#
################################################################################

LIBFSLPARSER_VERSION = 3.0.1
# No official download site from freescale, just this mirror
LIBFSLPARSER_SITE = http://download.ossystems.com.br/bsp/freescale/source
LIBFSLPARSER_SOURCE = libfslparser-$(LIBFSLPARSER_VERSION).bin
LIBFSLPARSER_LICENSE = Freescale Semiconductor Software License Agreement
LIBFSLPARSER_LICENSE_FILES = EULA EULA.txt
# This is a legal minefield: the EULA in the bin file specifies that
# the Board Support Package includes software and hardware (sic!)
# for which a separate license is needed...
LIBFSLPARSER_REDISTRIBUTE = NO

LIBFSLPARSER_INSTALL_STAGING = YES

# The archive is a shell-self-extractor of a bzipped tar. It happens
# to extract in the correct directory (libfslparser-x.y.z)
# The --force makes sure it doesn't fail if the source dir already exists.
# The --auto-accept skips the license check - not needed for us
# because we have legal-info
# Since the EULA in the bin file differs from the one in the tar file,
# extract the one from the bin file as well.
define LIBFSLPARSER_EXTRACT_CMDS
	awk 'BEGIN      { start=0; } \
	     /^EOEULA/  { start = 0; } \
	                { if (start) print; } \
	     /<<EOEULA/ { start=1; }'\
	    $(DL_DIR)/$(LIBFSLPARSER_SOURCE) > $(@D)/EULA
	cd $(BUILD_DIR); \
	sh $(DL_DIR)/$(LIBFSLPARSER_SOURCE) --force --auto-accept
endef

# The Makefile installs several versions of the libraries, but we only
# need one of them, depending on the platform.

$(eval $(autotools-package))
