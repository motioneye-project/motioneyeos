################################################################################
#
# xlib_libXpm -- X.Org Xpm library
#
################################################################################

XLIB_LIBXPM_VERSION = 3.5.6
XLIB_LIBXPM_SOURCE = libXpm-$(XLIB_LIBXPM_VERSION).tar.bz2
XLIB_LIBXPM_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXPM_AUTORECONF = YES
XLIB_LIBXPM_INSTALL_STAGING = YES
XLIB_LIBXPM_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXt xproto_xproto
XLIB_LIBXPM_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXpm))
