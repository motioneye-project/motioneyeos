################################################################################
#
# xlib_libXi -- X.Org Xi library
#
################################################################################

XLIB_LIBXI_VERSION = 1.1.3
XLIB_LIBXI_SOURCE = libXi-$(XLIB_LIBXI_VERSION).tar.bz2
XLIB_LIBXI_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXI_AUTORECONF = NO
XLIB_LIBXI_INSTALL_STAGING = YES
XLIB_LIBXI_INSTALL_TARGET = YES
XLIB_LIBXI_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-strip
XLIB_LIBXI_DEPENDENCIES = xproto_inputproto xlib_libX11 xlib_libXext xproto_xproto
XLIB_LIBXI_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXi))
