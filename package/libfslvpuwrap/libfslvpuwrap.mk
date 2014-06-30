################################################################################
#
# libfslvpuwrap
#
################################################################################

LIBFSLVPUWRAP_VERSION = 1.0.46
LIBFSLVPUWRAP_SITE = $(FREESCALE_IMX_SITE)
LIBFSLVPUWRAP_SOURCE = libfslvpuwrap-$(LIBFSLVPUWRAP_VERSION).bin
LIBFSLVPUWRAP_LICENSE = Freescale Semiconductor Software License Agreement
# N.B.: the content of the two license files is different
LIBFSLVPUWRAP_LICENSE_FILES = EULA EULA.txt
LIBFSLVPUWRAP_REDISTRIBUTE = NO

LIBFSLVPUWRAP_INSTALL_STAGING = YES

LIBFSLVPUWRAP_DEPENDENCIES += imx-vpu

# The archive is a shell-self-extractor of a bzipped tar. It happens
# to extract in the correct directory (libfslvpuwrap-x.y.z)
# The --force makes sure it doesn't fail if the source dir already exists.
# The --auto-accept skips the license check - not needed for us
# because we have legal-info
# Since the EULA in the bin file differs from the one in the tar file,
# extract the one from the bin file as well.
define LIBFSLVPUWRAP_EXTRACT_CMDS
	awk 'BEGIN      { start=0; } \
	     /^EOEULA/  { start = 0; } \
	                { if (start) print; } \
	     /<<EOEULA/ { start=1; }'\
	    $(DL_DIR)/$(LIBFSLVPUWRAP_SOURCE) > $(@D)/EULA
	cd $(BUILD_DIR); \
	sh $(DL_DIR)/$(LIBFSLVPUWRAP_SOURCE) --force --auto-accept
endef

$(eval $(autotools-package))
