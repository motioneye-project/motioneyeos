###############################################################################
#
# fmc
#
###############################################################################

FMC_VERSION = fsl-sdk-v1.5-rc3
FMC_SITE = git://git.freescale.com/ppc/sdk/fmc.git
FMC_LICENSE = MIT
FMC_LICENSE_FILES = COPYING
FMC_DEPENDENCIES = libxml2 tclap fmlib

FMC_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	FMD_USPACE_HEADER_PATH="$(STAGING_DIR)/usr/include/fmd" \
	FMD_USPACE_LIB_PATH="$(STAGING_DIR)/usr/lib" \
	LIBXML2_HEADER_PATH="$(STAGING_DIR)/usr/include/libxml2" \
	TCLAP_HEADER_PATH="$(STAGING_DIR)/usr/include"

define FMC_BUILD_CMDS
	# The linking step has dependency issues so using MAKE1
	$(TARGET_MAKE_ENV) $(MAKE1) $(FMC_MAKE_OPTS) -C $(@D)/source
endef

define FMC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/source/fmc $(TARGET_DIR)/usr/sbin/fmc
	cp -dpfr $(@D)/etc/fmc $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))
