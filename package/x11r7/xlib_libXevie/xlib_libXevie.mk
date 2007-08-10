################################################################################
#
# xlib_libXevie -- X.Org Xevie library
#
################################################################################

XLIB_LIBXEVIE_VERSION = 1.0.2
XLIB_LIBXEVIE_SOURCE = libXevie-$(XLIB_LIBXEVIE_VERSION).tar.bz2
XLIB_LIBXEVIE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXEVIE_AUTORECONF = YES
XLIB_LIBXEVIE_INSTALL_STAGING = YES
XLIB_LIBXEVIE_DEPENDANCIES = xlib_libX11 xlib_libXext xproto_evieext xproto_xproto
XLIB_LIBXEVIE_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXevie))
