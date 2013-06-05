################################################################################
#
# libfslcodec
#
################################################################################

LIBFSLCODEC_VERSION = 3.0.1
# No official download site from freescale, just this mirror
LIBFSLCODEC_SITE = http://download.ossystems.com.br/bsp/freescale/source
LIBFSLCODEC_SOURCE = libfslcodec-$(LIBFSLCODEC_VERSION).bin
LIBFSLCODEC_LICENSE = Freescale Semiconductor Software License Agreement, BSD-3c (flac, ogg headers)
LIBFSLCODEC_LICENSE_FILES = EULA EULA.txt
# This is a legal minefield: the EULA in the bin file specifies that
# the Board Support Package includes software and hardware (sic!)
# for which a separate license is needed...
LIBFSLCODEC_REDISTRIBUTE = NO

LIBFSLCODEC_INSTALL_STAGING = YES

# The archive is a shell-self-extractor of a bzipped tar. It happens
# to extract in the correct directory (libfslcodec-x.y.z)
# The --force makes sure it doesn't fail if the source dir already exists.
# The --auto-accept skips the license check - not needed for us
# because we have legal-info.
# Since the EULA in the bin file differs from the one in the tar file,
# extract the one from the bin file as well.
define LIBFSLCODEC_EXTRACT_CMDS
	awk 'BEGIN      { start=0; } \
	     /^EOEULA/  { start = 0; } \
	                { if (start) print; } \
	     /<<EOEULA/ { start=1; }'\
	    $(DL_DIR)/$(LIBFSLCODEC_SOURCE) > $(@D)/EULA
	cd $(BUILD_DIR); \
	sh $(DL_DIR)/$(LIBFSLCODEC_SOURCE) --force --auto-accept
endef

# FIXME The Makefile installs both the arm9 and arm11 versions of the
# libraries, but we only need one of them.

$(eval $(autotools-package))
