################################################################################
#
# fmc
#
################################################################################

FMC_VERSION = fsl-sdk-v2.0
FMC_SITE = https://source.codeaurora.org/external/qoriq/qoriq-yocto-sdk/fmc
FMC_SITE_METHOD = git
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

ifeq ($(BR2_powerpc64),y)
FMC_MAKE_OPTS += M64BIT=1
endif

# fmc's platform is the same as fmlib's.
FMC_PLATFORM = $(call qstrip,$(BR2_PACKAGE_FMLIB_PLATFORM))

define FMC_BUILD_CMDS
	$(SED) "s:P4080:$(FMC_PLATFORM):g" $(@D)/source/Makefile
	# The linking step has dependency issues so using MAKE1
	$(TARGET_MAKE_ENV) $(MAKE1) $(FMC_MAKE_OPTS) -C $(@D)/source
endef

define FMC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/source/fmc $(TARGET_DIR)/usr/sbin/fmc
	cp -dpfr $(@D)/etc/fmc $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))
