################################################################################
#
# xlib_libXi -- X.Org Xi library
#
################################################################################

XLIB_LIBXI_VERSION = 1.0.2
XLIB_LIBXI_SOURCE = libXi-$(XLIB_LIBXI_VERSION).tar.bz2
XLIB_LIBXI_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXI_AUTORECONF = YES
XLIB_LIBXI_INSTALL_STAGING = YES
XLIB_LIBXI_DEPENDENCIES = xproto_inputproto xlib_libX11 xlib_libXext xproto_xproto
XLIB_LIBXI_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXi))
