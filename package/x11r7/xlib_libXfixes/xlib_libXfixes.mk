################################################################################
#
# xlib_libXfixes -- X.Org Xfixes library
#
################################################################################

XLIB_LIBXFIXES_VERSION = 4.0.3
XLIB_LIBXFIXES_SOURCE = libXfixes-$(XLIB_LIBXFIXES_VERSION).tar.bz2
XLIB_LIBXFIXES_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFIXES_AUTORECONF = YES
XLIB_LIBXFIXES_INSTALL_STAGING = YES
XLIB_LIBXFIXES_DEPENDENCIES = xproto_fixesproto xlib_libX11 xproto_xextproto xproto_xproto
XLIB_LIBXFIXES_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXfixes))
