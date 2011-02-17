################################################################################
#
# xlib_libXau -- X.Org Xau library
#
################################################################################

XLIB_LIBXAU_VERSION = 1.0.5
XLIB_LIBXAU_SOURCE = libXau-$(XLIB_LIBXAU_VERSION).tar.bz2
XLIB_LIBXAU_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXAU_AUTORECONF = NO
XLIB_LIBXAU_INSTALL_STAGING = YES
XLIB_LIBXAU_DEPENDENCIES = xutil_util-macros xproto_xproto
XLIB_LIBXAU_CONF_OPT = --enable-shared --disable-static

HOST_XLIB_LIBXAU_DEPENDENCIES = host-xutil_util-macros host-xproto_xproto
HOST_XLIB_LIBXAU_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXau))
$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXau,host))
