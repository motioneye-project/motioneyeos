################################################################################
#
# xlib_libXxf86dga
#
################################################################################

XLIB_LIBXXF86DGA_VERSION = 1.1.4
XLIB_LIBXXF86DGA_SOURCE = libXxf86dga-$(XLIB_LIBXXF86DGA_VERSION).tar.bz2
XLIB_LIBXXF86DGA_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXXF86DGA_LICENSE = MIT
XLIB_LIBXXF86DGA_LICENSE_FILES = COPYING
XLIB_LIBXXF86DGA_INSTALL_STAGING = YES
XLIB_LIBXXF86DGA_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_xf86dgaproto xproto_xproto
XLIB_LIBXXF86DGA_CONF_OPT = --disable-malloc0returnsnull

$(eval $(autotools-package))
