################################################################################
#
# xlib_libXTrap -- X.Org XTrap library
#
################################################################################

XLIB_LIBXTRAP_VERSION = 1.0.0
XLIB_LIBXTRAP_SOURCE = libXTrap-$(XLIB_LIBXTRAP_VERSION).tar.bz2
XLIB_LIBXTRAP_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXTRAP_AUTORECONF = YES
XLIB_LIBXTRAP_INSTALL_STAGING = YES
XLIB_LIBXTRAP_DEPENDENCIES = xlib_libX11 xlib_libXt xlib_libXext xproto_trapproto
XLIB_LIBXTRAP_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXTrap))
