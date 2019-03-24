################################################################################
#
# xlib_libXext
#
################################################################################

XLIB_LIBXEXT_VERSION = 1.3.4
XLIB_LIBXEXT_SOURCE = libXext-$(XLIB_LIBXEXT_VERSION).tar.bz2
XLIB_LIBXEXT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXEXT_LICENSE = MIT
XLIB_LIBXEXT_LICENSE_FILES = COPYING
XLIB_LIBXEXT_INSTALL_STAGING = YES
XLIB_LIBXEXT_DEPENDENCIES = xlib_libX11 xorgproto
XLIB_LIBXEXT_CONF_OPTS = --disable-malloc0returnsnull

$(eval $(autotools-package))
