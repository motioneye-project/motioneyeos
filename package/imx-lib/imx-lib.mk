#############################################################
#
# imx-lib
#
#############################################################

IMX_LIB_VERSION = 12.09.01
# No official download site from freescale, just this mirror
IMX_LIB_SITE    = http://download.ossystems.com.br/bsp/freescale/source
IMX_LIB_LICENSE = LGPLv2.1+
# No license file included

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
