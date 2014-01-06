################################################################################
#
# xlib_libXres
#
################################################################################

XLIB_LIBXRES_VERSION = 1.0.7
XLIB_LIBXRES_SOURCE = libXres-$(XLIB_LIBXRES_VERSION).tar.bz2
XLIB_LIBXRES_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXRES_LICENSE = MIT
XLIB_LIBXRES_LICENSE_FILES = COPYING
XLIB_LIBXRES_INSTALL_STAGING = YES
XLIB_LIBXRES_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_resourceproto xproto_xproto
XLIB_LIBXRES_CONF_OPT = --disable-malloc0returnsnull

$(eval $(autotools-package))
