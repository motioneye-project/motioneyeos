################################################################################
#
# xlib_libXp -- X.Org Xp library
#
################################################################################

XLIB_LIBXP_VERSION = 1.0.0
XLIB_LIBXP_SOURCE = libXp-$(XLIB_LIBXP_VERSION).tar.bz2
XLIB_LIBXP_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXP_AUTORECONF = NO
XLIB_LIBXP_INSTALL_STAGING = YES
XLIB_LIBXP_DEPENDENCIES = xlib_libX11 xlib_libXau xlib_libXext xproto_printproto
XLIB_LIBXP_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXp))
