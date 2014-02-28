################################################################################
#
# imx-lib
#
################################################################################

IMX_LIB_VERSION = $(FREESCALE_IMX_VERSION)
IMX_LIB_SITE    = $(FREESCALE_IMX_SITE)
IMX_LIB_LICENSE = Freescale License (vpu), LGPLv2.1+ (the rest)
IMX_LIB_LICENSE_FILES = EULA
IMX_LIB_SOURCE = imx-lib-$(IMX_LIB_VERSION).bin

IMX_LIB_INSTALL_STAGING = YES

# imx-lib needs access to imx-specific kernel headers
IMX_LIB_DEPENDENCIES += linux
IMX_LIB_INCLUDE = \
	-I$(LINUX_DIR)/drivers/mxc/security/rng/include \
	-I$(LINUX_DIR)/drivers/mxc/security/sahara2/include \
	-idirafter $(LINUX_DIR)/include

IMX_LIB_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(TARGET_CONFIGURE_OPTS) \
	CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
	PLATFORM=$(BR2_PACKAGE_IMX_LIB_PLATFORM) \
	INCLUDE="$(IMX_LIB_INCLUDE)"

# The archive is a shell-self-extractor of a bzipped tar. It happens
# to extract in the correct directory (imx-lib-x.y.z)
# The --force makes sure it doesn't fail if the source dir already exists.
# The --auto-accept skips the license check - not needed for us
# because we have legal-info
# Since there's a EULA in the bin file, extract it to imx-lib-x.y.z/EULA
#
define IMX_LIB_EXTRACT_CMDS
	awk 'BEGIN      { start=0; } \
	     /^EOEULA/  { start = 0; } \
	                { if (start) print; } \
	     /<<EOEULA/ { start=1; }'\
	    $(DL_DIR)/$(IMX_LIB_SOURCE) > $(@D)/EULA
	cd $(BUILD_DIR); \
	sh $(DL_DIR)/$(IMX_LIB_SOURCE) --force --auto-accept
endef

define IMX_LIB_BUILD_CMDS
	$(IMX_LIB_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define IMX_LIB_INSTALL_STAGING_CMDS
	$(IMX_LIB_MAKE_ENV) $(MAKE1) -C $(@D) DEST_DIR=$(STAGING_DIR) install
endef

define IMX_LIB_INSTALL_TARGET_CMDS
	$(IMX_LIB_MAKE_ENV) $(MAKE1) -C $(@D) DEST_DIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
