################################################################################
#
# xlib_libXaw -- X.Org Xaw library
#
################################################################################

XLIB_LIBXAW_VERSION = 1.0.2
XLIB_LIBXAW_SOURCE = libXaw-$(XLIB_LIBXAW_VERSION).tar.bz2
XLIB_LIBXAW_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXAW_AUTORECONF = YES
XLIB_LIBXAW_INSTALL_STAGING = YES
XLIB_LIBXAW_DEPENDENCIES = xlib_libX11 xlib_libXt xlib_libXmu xlib_libXpm xproto_xproto xlib_libXp
XLIB_LIBXAW_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXaw))
