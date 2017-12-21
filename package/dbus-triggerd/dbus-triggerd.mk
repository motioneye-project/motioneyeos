################################################################################
#
# dbus-triggerd
#
################################################################################

DBUS_TRIGGERD_VERSION = ba3dbec805cb707c94c54de21666bf18b79bcc09
DBUS_TRIGGERD_SITE = git://rg42.org/dbustriggerd.git
DBUS_TRIGGERD_LICENSE = GPL-2.0+
DBUS_TRIGGERD_LICENSE_FILES = dbus-triggerd.c
DBUS_TRIGGERD_DEPENDENCIES = host-pkgconf dbus

define DBUS_TRIGGERD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define DBUS_TRIGGERD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

$(eval $(generic-package))
