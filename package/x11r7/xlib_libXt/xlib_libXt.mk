################################################################################
#
# xlib_libXt -- X.Org Xt library
#
################################################################################

XLIB_LIBXT_VERSION = 1.0.7
XLIB_LIBXT_SOURCE = libXt-$(XLIB_LIBXT_VERSION).tar.bz2
XLIB_LIBXT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXT_AUTORECONF = YES
XLIB_LIBXT_INSTALL_STAGING = YES
XLIB_LIBXT_DEPENDENCIES = xlib_libSM xlib_libX11 xproto_kbproto xproto_xproto xcb-proto libxcb host-xproto_xproto
XLIB_LIBXT_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static --disable-install-makestrs

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXt))
