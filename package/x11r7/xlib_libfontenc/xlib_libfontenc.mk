################################################################################
#
# xlib_libfontenc -- X.Org fontenc library
#
################################################################################

XLIB_LIBFONTENC_VERSION = 1.0.4
XLIB_LIBFONTENC_SOURCE = libfontenc-$(XLIB_LIBFONTENC_VERSION).tar.bz2
XLIB_LIBFONTENC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBFONTENC_AUTORECONF = YES
XLIB_LIBFONTENC_INSTALL_STAGING = YES
XLIB_LIBFONTENC_DEPENDENCIES = xproto_xproto
XLIB_LIBFONTENC_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libfontenc))
