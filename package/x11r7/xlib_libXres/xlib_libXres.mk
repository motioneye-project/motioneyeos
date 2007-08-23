################################################################################
#
# xlib_libXres -- X.Org XRes library
#
################################################################################

XLIB_LIBXRES_VERSION = 1.0.3
XLIB_LIBXRES_SOURCE = libXres-$(XLIB_LIBXRES_VERSION).tar.bz2
XLIB_LIBXRES_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXRES_AUTORECONF = YES
XLIB_LIBXRES_INSTALL_STAGING = YES
XLIB_LIBXRES_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_resourceproto xproto_xproto
XLIB_LIBXRES_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXres))
