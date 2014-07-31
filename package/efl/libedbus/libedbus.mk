################################################################################
#
# libedbus
#
################################################################################

LIBEDBUS_VERSION = $(EFL_VERSION)
LIBEDBUS_SOURCE = e_dbus-$(LIBEDBUS_VERSION).tar.bz2
LIBEDBUS_SITE = http://download.enlightenment.org/releases
LIBEDBUS_LICENSE = BSD-2c
LIBEDBUS_LICENSE_FILES = COPYING

LIBEDBUS_INSTALL_STAGING = YES

LIBEDBUS_DEPENDENCIES = host-pkgconf dbus libeina libecore

ifeq ($(BR2_PACKAGE_LIBEDBUS_BLUEZ),y)
LIBEDBUS_CONF_OPT += --enable-ebluez
LIBEDBUS_DEPENDENCIES += bluez_utils
else
LIBEDBUS_CONF_OPT += --disable-ebluez
endif

ifeq ($(BR2_PACKAGE_LIBEDBUS_CONNMAN),y)
LIBEDBUS_CONF_OPT += --enable-econnman0_7x
LIBEDBUS_DEPENDENCIES += connman
else
LIBEDBUS_CONF_OPT += --disable-econnman0_7x
endif

ifeq ($(BR2_PACKAGE_LIBEDBUS_NOTIFY),y)
LIBEDBUS_CONF_OPT += --enable-enotify --disable-edbus-notify-test
else
LIBEDBUS_CONF_OPT += --disable-enotify
endif

$(eval $(autotools-package))
