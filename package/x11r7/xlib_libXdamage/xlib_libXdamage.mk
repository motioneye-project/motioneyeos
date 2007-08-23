################################################################################
#
# xlib_libXdamage -- X.Org Xdamage library
#
################################################################################

XLIB_LIBXDAMAGE_VERSION = 1.0.4
XLIB_LIBXDAMAGE_SOURCE = libXdamage-$(XLIB_LIBXDAMAGE_VERSION).tar.bz2
XLIB_LIBXDAMAGE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXDAMAGE_AUTORECONF = YES
XLIB_LIBXDAMAGE_INSTALL_STAGING = YES
XLIB_LIBXDAMAGE_DEPENDENCIES = xproto_damageproto xlib_libX11 xlib_libXfixes xproto_xproto
XLIB_LIBXDAMAGE_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXdamage))
