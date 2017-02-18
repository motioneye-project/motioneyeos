################################################################################
#
# xlib_libXdamage
#
################################################################################

XLIB_LIBXDAMAGE_VERSION = 1.1.4
XLIB_LIBXDAMAGE_SOURCE = libXdamage-$(XLIB_LIBXDAMAGE_VERSION).tar.bz2
XLIB_LIBXDAMAGE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXDAMAGE_LICENSE = MIT
XLIB_LIBXDAMAGE_LICENSE_FILES = COPYING
XLIB_LIBXDAMAGE_INSTALL_STAGING = YES
XLIB_LIBXDAMAGE_DEPENDENCIES = xproto_damageproto xlib_libX11 xlib_libXfixes xproto_xproto

$(eval $(autotools-package))
