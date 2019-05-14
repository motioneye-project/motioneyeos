################################################################################
#
# xapp_oclock
#
################################################################################

XAPP_OCLOCK_VERSION = 1.0.4
XAPP_OCLOCK_SOURCE = oclock-$(XAPP_OCLOCK_VERSION).tar.bz2
XAPP_OCLOCK_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_OCLOCK_LICENSE = MIT
XAPP_OCLOCK_LICENSE_FILES = COPYING
XAPP_OCLOCK_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXmu
XAPP_OCLOCK_CONF_OPTS = --with-appdefaultdir=/usr/share/X11/app-defaults

ifeq ($(BR2_PACKAGE_XLIB_LIBXKBFILE),y)
XAPP_OCLOCK_CONF_OPTS += --with-xkb
XAPP_OCLOCK_DEPENDENCIES += xlib_libxkbfile
else
XAPP_OCLOCK_CONF_OPTS += --without-xkb
endif

$(eval $(autotools-package))
