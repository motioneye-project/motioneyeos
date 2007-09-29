################################################################################
#
# xlib_libxkbui -- X.Org xkbui library
#
################################################################################

XLIB_LIBXKBUI_VERSION = 1.0.2
XLIB_LIBXKBUI_SOURCE = libxkbui-$(XLIB_LIBXKBUI_VERSION).tar.bz2
XLIB_LIBXKBUI_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXKBUI_AUTORECONF = YES
XLIB_LIBXKBUI_INSTALL_STAGING = YES
XLIB_LIBXKBUI_DEPENDENCIES = xlib_libxkbfile xlib_libXt xproto_kbproto
XLIB_LIBXKBUI_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libxkbui))
