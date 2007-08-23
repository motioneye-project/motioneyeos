################################################################################
#
# xlib_libXfont -- X.Org Xfont library
#
################################################################################

XLIB_LIBXFONT_VERSION = 1.2.7
XLIB_LIBXFONT_SOURCE = libXfont-$(XLIB_LIBXFONT_VERSION).tar.bz2
XLIB_LIBXFONT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFONT_AUTORECONF = YES
XLIB_LIBXFONT_INSTALL_STAGING = YES
XLIB_LIBXFONT_DEPENDENCIES = freetype xlib_libfontenc xlib_xtrans xproto_fontcacheproto xproto_fontsproto xproto_xproto xfont_encodings
XLIB_LIBXFONT_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXfont))
