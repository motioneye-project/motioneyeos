################################################################################
#
# xlib_libXinerama
#
################################################################################

XLIB_LIBXINERAMA_VERSION = 1.1.4
XLIB_LIBXINERAMA_SOURCE = libXinerama-$(XLIB_LIBXINERAMA_VERSION).tar.bz2
XLIB_LIBXINERAMA_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXINERAMA_LICENSE = MIT
XLIB_LIBXINERAMA_LICENSE_FILES = COPYING
XLIB_LIBXINERAMA_INSTALL_STAGING = YES
XLIB_LIBXINERAMA_DEPENDENCIES = xlib_libX11 xlib_libXext xorgproto
XLIB_LIBXINERAMA_CONF_OPTS = --disable-malloc0returnsnull

$(eval $(autotools-package))
