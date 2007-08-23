################################################################################
#
# xlib_libXxf86misc -- X.Org Xxf86misc library
#
################################################################################

XLIB_LIBXXF86MISC_VERSION = 1.0.1
XLIB_LIBXXF86MISC_SOURCE = libXxf86misc-$(XLIB_LIBXXF86MISC_VERSION).tar.bz2
XLIB_LIBXXF86MISC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXXF86MISC_AUTORECONF = YES
XLIB_LIBXXF86MISC_INSTALL_STAGING = YES
XLIB_LIBXXF86MISC_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_xf86miscproto xproto_xproto
XLIB_LIBXXF86MISC_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXxf86misc))
