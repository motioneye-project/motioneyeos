################################################################################
#
# xlib_libxkbfile -- X.Org xkbfile library
#
################################################################################

XLIB_LIBXKBFILE_VERSION = 1.0.4
XLIB_LIBXKBFILE_SOURCE = libxkbfile-$(XLIB_LIBXKBFILE_VERSION).tar.bz2
XLIB_LIBXKBFILE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXKBFILE_AUTORECONF = NO
XLIB_LIBXKBFILE_INSTALL_STAGING = YES
XLIB_LIBXKBFILE_DEPENDENCIES = xlib_libX11 xproto_kbproto
XLIB_LIBXKBFILE_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libxkbfile))
