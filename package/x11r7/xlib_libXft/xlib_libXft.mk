################################################################################
#
# xlib_libXft -- X.Org Xft library
#
################################################################################

XLIB_LIBXFT_VERSION = 2.1.12
XLIB_LIBXFT_SOURCE = libXft-$(XLIB_LIBXFT_VERSION).tar.bz2
XLIB_LIBXFT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFT_AUTORECONF = YES
XLIB_LIBXFT_INSTALL_STAGING = YES
XLIB_LIBXFT_DEPENDANCIES = fontconfig freetype xlib_libX11 xlib_libXext xlib_libXrender xproto_xproto
XLIB_LIBXFT_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXft))
