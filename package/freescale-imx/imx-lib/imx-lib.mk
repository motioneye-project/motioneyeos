################################################################################
#
# imx-lib
#
################################################################################

IMX_LIB_VERSION = rel_imx_4.9.x_1.0.0_ga
IMX_LIB_SITE = https://source.codeaurora.org/external/imx/imx-lib
IMX_LIB_SITE_METHOD = git
IMX_LIB_LICENSE = LGPL-2.1+
IMX_LIB_LICENSE_FILES = COPYING-LGPL-2.1

IMX_LIB_INSTALL_STAGING = YES

# imx-lib needs access to imx-specific kernel headers
IMX_LIB_DEPENDENCIES += linux
IMX_LIB_INCLUDE = \
	-idirafter $(LINUX_DIR)/include/uapi

IMX_LIB_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(TARGET_CONFIGURE_OPTS) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	PLATFORM=$(BR2_PACKAGE_FREESCALE_IMX_PLATFORM) \
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
