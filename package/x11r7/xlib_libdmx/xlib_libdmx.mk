################################################################################
#
# xlib_libdmx -- X.Org dmx library
#
################################################################################

XLIB_LIBDMX_VERSION = 1.0.2
XLIB_LIBDMX_SOURCE = libdmx-$(XLIB_LIBDMX_VERSION).tar.bz2
XLIB_LIBDMX_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBDMX_AUTORECONF = YES
XLIB_LIBDMX_INSTALL_STAGING = YES
XLIB_LIBDMX_DEPENDENCIES = xlib_libX11 xlib_libXext xproto_dmxproto
XLIB_LIBDMX_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libdmx))
