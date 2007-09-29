################################################################################
#
# xlib_libXau -- X.Org Xau library
#
################################################################################

XLIB_LIBXAU_VERSION = 1.0.3
XLIB_LIBXAU_SOURCE = libXau-$(XLIB_LIBXAU_VERSION).tar.bz2
XLIB_LIBXAU_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXAU_AUTORECONF = YES
XLIB_LIBXAU_INSTALL_STAGING = YES
XLIB_LIBXAU_DEPENDENCIES = xproto_xproto xproto_xproto xutil_util-macros
XLIB_LIBXAU_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXau))
