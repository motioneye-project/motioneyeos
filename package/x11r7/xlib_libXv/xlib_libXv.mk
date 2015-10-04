################################################################################
#
# xlib_libXv
#
################################################################################

XLIB_LIBXV_VERSION = 1.0.10
XLIB_LIBXV_SOURCE = libXv-$(XLIB_LIBXV_VERSION).tar.bz2
XLIB_LIBXV_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXV_LICENSE = MIT
XLIB_LIBXV_LICENSE_FILES = COPYING
XLIB_LIBXV_INSTALL_STAGING = YES
XLIB_LIBXV_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_videoproto xproto_xproto
XLIB_LIBXV_CONF_OPTS = --disable-malloc0returnsnull

$(eval $(autotools-package))
