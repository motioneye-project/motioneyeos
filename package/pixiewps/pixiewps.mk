################################################################################
#
# pixiewps
#
################################################################################

PIXIEWPS_VERSION = 9e5bdc6c86c8487b2a6107d5ab3559ed5c738c59
PIXIEWPS_SITE = $(call github,wiire-a,pixiewps,$(PIXIEWPS_VERSION))
PIXIEWPS_LICENSE = GPL-3.0+
PIXIEWPS_LICENSE_FILES = LICENSE.md

define PIXIEWPS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define PIXIEWPS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) \
		PREFIX=/usr -C $(@D) install
endef

$(eval $(generic-package))
