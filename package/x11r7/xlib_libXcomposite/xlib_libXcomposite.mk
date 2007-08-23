################################################################################
#
# xlib_libXcomposite -- X.Org Xcomposite library
#
################################################################################

XLIB_LIBXCOMPOSITE_VERSION = 0.3.1
XLIB_LIBXCOMPOSITE_SOURCE = libXcomposite-$(XLIB_LIBXCOMPOSITE_VERSION).tar.bz2
XLIB_LIBXCOMPOSITE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXCOMPOSITE_AUTORECONF = YES
XLIB_LIBXCOMPOSITE_INSTALL_STAGING = YES
XLIB_LIBXCOMPOSITE_DEPENDENCIES = xproto_compositeproto xlib_libX11 xlib_libXext xlib_libXfixes xproto_xproto
XLIB_LIBXCOMPOSITE_CONF_OPT = --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libXcomposite))
