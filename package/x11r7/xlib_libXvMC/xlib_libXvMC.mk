################################################################################
#
# xlib_libXvMC -- X.Org XvMC library
#
################################################################################

XLIB_LIBXVMC_VERSION = 1.0.4
XLIB_LIBXVMC_SOURCE = libXvMC-$(XLIB_LIBXVMC_VERSION).tar.bz2
XLIB_LIBXVMC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXVMC_AUTORECONF = YES
XLIB_LIBXVMC_INSTALL_STAGING = YES
XLIB_LIBXVMC_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXv xproto_videoproto xproto_xproto
XLIB_LIBXVMC_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXvMC))
