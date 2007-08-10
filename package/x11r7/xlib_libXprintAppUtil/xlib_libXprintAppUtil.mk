################################################################################
#
# xlib_libXprintAppUtil -- X.Org XprintAppUtil library
#
################################################################################

XLIB_LIBXPRINTAPPUTIL_VERSION = 1.0.1
XLIB_LIBXPRINTAPPUTIL_SOURCE = libXprintAppUtil-$(XLIB_LIBXPRINTAPPUTIL_VERSION).tar.bz2
XLIB_LIBXPRINTAPPUTIL_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXPRINTAPPUTIL_AUTORECONF = YES
XLIB_LIBXPRINTAPPUTIL_INSTALL_STAGING = YES
XLIB_LIBXPRINTAPPUTIL_DEPENDANCIES = xlib_libX11 xlib_libXp xlib_libXprintUtil
XLIB_LIBXPRINTAPPUTIL_CONF_OPT =  --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXprintAppUtil))
