################################################################################
#
# xlib_libXv -- X.Org Xv library
#
################################################################################

XLIB_LIBXV_VERSION = 1.0.3
XLIB_LIBXV_SOURCE = libXv-$(XLIB_LIBXV_VERSION).tar.bz2
XLIB_LIBXV_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXV_AUTORECONF = YES
XLIB_LIBXV_INSTALL_STAGING = YES
XLIB_LIBXV_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_videoproto xproto_xproto
XLIB_LIBXV_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXv))
