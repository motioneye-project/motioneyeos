################################################################################
#
# xlib_liboldX -- X.Org oldX library
#
################################################################################

XLIB_LIBOLDX_VERSION = 1.0.1
XLIB_LIBOLDX_SOURCE = liboldX-$(XLIB_LIBOLDX_VERSION).tar.bz2
XLIB_LIBOLDX_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBOLDX_INSTALL_STAGING = YES
XLIB_LIBOLDX_DEPENDENCIES = xlib_libX11
XLIB_LIBOLDX_CONF_OPT = --disable-malloc0returnsnull

$(eval $(autotools-package))
