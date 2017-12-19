################################################################################
#
# shapelib
#
################################################################################

SHAPELIB_VERSION = 1.3.0
SHAPELIB_SITE = http://download.osgeo.org/shapelib
SHAPELIB_LICENSE = MIT or LGPL-2.0
SHAPELIB_LICENSE_FILES = web/license.html LICENSE.LGPL
SHAPELIB_INSTALL_STAGING = YES

define SHAPELIB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define SHAPELIB_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=$(STAGING_DIR)/usr/ lib_install
endef

define SHAPELIB_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=$(TARGET_DIR)/usr/ bin_install
endef

$(eval $(generic-package))
