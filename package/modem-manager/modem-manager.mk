################################################################################
#
# modem-manager
#
################################################################################

MODEM_MANAGER_VERSION = 1.6.4
MODEM_MANAGER_SOURCE = ModemManager-$(MODEM_MANAGER_VERSION).tar.xz
MODEM_MANAGER_SITE = http://www.freedesktop.org/software/ModemManager
MODEM_MANAGER_LICENSE = GPL-2.0+ (programs, plugins), LGPL-2.0+ (libmm-glib)
MODEM_MANAGER_LICENSE_FILES = COPYING
MODEM_MANAGER_DEPENDENCIES = host-pkgconf udev dbus-glib host-intltool libgudev
MODEM_MANAGER_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_MODEM_MANAGER_LIBQMI),y)
MODEM_MANAGER_DEPENDENCIES += libqmi
MODEM_MANAGER_CONF_OPTS += --with-qmi
else
MODEM_MANAGER_CONF_OPTS += --without-qmi
endif

ifeq ($(BR2_PACKAGE_MODEM_MANAGER_LIBMBIM),y)
MODEM_MANAGER_DEPENDENCIES += libmbim
MODEM_MANAGER_CONF_OPTS += --with-mbim
else
MODEM_MANAGER_CONF_OPTS += --without-mbim
endif

define MODEM_MANAGER_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/modem-manager/S44modem-manager \
		$(TARGET_DIR)/etc/init.d/S44modem-manager
endef

$(eval $(autotools-package))
