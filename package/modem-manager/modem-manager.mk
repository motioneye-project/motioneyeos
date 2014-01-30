################################################################################
#
# modem-manager
#
################################################################################

MODEM_MANAGER_VERSION = 1.2.0
MODEM_MANAGER_SOURCE = ModemManager-$(MODEM_MANAGER_VERSION).tar.xz
MODEM_MANAGER_SITE = http://www.freedesktop.org/software/ModemManager/
MODEM_MANAGER_LICENSE = GPLv2+ (programs, plugins), LGPLv2+ (libmm-glib)
MODEM_MANAGER_LICENSE_FILES = COPYING
MODEM_MANAGER_DEPENDENCIES = host-pkgconf udev dbus-glib host-intltool

ifeq ($(BR2_PACKAGE_MODEM_MANAGER_LIBQMI),y)
	MODEM_MANAGER_DEPENDENCIES += libqmi
	MODEM_MANAGER_CONF_OPT += --with-qmi
else
	MODEM_MANAGER_CONF_OPT += --without-qmi
endif

ifeq ($(BR2_PACKAGE_MODEM_MANAGER_LIBMBIM),y)
	MODEM_MANAGER_DEPENDENCIES += libmbim
	MODEM_MANAGER_CONF_OPT += --with-mbim
else
	MODEM_MANAGER_CONF_OPT += --without-mbim
endif

$(eval $(autotools-package))
