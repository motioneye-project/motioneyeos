################################################################################
#
# xlib_libXrandr -- X.Org Xrandr library
#
################################################################################

XLIB_LIBXRANDR_VERSION = 1.1.2
XLIB_LIBXRANDR_SOURCE = libXrandr-$(XLIB_LIBXRANDR_VERSION).tar.bz2
XLIB_LIBXRANDR_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXRANDR_AUTORECONF = YES
XLIB_LIBXRANDR_INSTALL_STAGING = YES
XLIB_LIBXRANDR_DEPENDENCIES = xproto_randrproto xlib_libX11 xlib_libXext xlib_libXrender xproto_renderproto xproto_xproto
XLIB_LIBXRANDR_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXrandr))
