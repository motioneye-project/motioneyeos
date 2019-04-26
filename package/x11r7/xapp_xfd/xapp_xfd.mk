################################################################################
#
# xapp_xfd
#
################################################################################

XAPP_XFD_VERSION = 1.1.3
XAPP_XFD_SOURCE = xfd-$(XAPP_XFD_VERSION).tar.bz2
XAPP_XFD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XFD_LICENSE = MIT
XAPP_XFD_LICENSE_FILES = COPYING
XAPP_XFD_DEPENDENCIES = \
	freetype \
	fontconfig \
	xlib_libXaw \
	xlib_libXft \
	$(TARGET_NLS_DEPENDENCIES)
XAPP_XFD_CONF_OPTS = --with-appdefaultdir=/usr/share/X11/app-defaults
XAPP_XFD_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_XLIB_LIBXKBFILE),y)
XAPP_XFD_CONF_OPTS += --with-xkb
XAPP_XFD_DEPENDENCIES += xlib_libxkbfile
else
XAPP_XFD_CONF_OPTS += --without-xkb
endif

$(eval $(autotools-package))
