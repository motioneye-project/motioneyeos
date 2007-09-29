################################################################################
#
# xlib_libXcursor -- X.Org Xcursor library
#
################################################################################

XLIB_LIBXCURSOR_VERSION = 1.1.8
XLIB_LIBXCURSOR_SOURCE = libXcursor-$(XLIB_LIBXCURSOR_VERSION).tar.bz2
XLIB_LIBXCURSOR_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXCURSOR_AUTORECONF = YES
XLIB_LIBXCURSOR_INSTALL_STAGING = YES
XLIB_LIBXCURSOR_DEPENDENCIES = xlib_libX11 xlib_libXfixes xlib_libXrender xproto_xproto
XLIB_LIBXCURSOR_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXcursor))
