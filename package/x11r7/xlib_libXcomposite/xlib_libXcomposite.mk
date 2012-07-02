################################################################################
#
# xlib_libXcomposite -- X.Org Xcomposite library
#
################################################################################

XLIB_LIBXCOMPOSITE_VERSION = 0.4.1
XLIB_LIBXCOMPOSITE_SOURCE = libXcomposite-$(XLIB_LIBXCOMPOSITE_VERSION).tar.bz2
XLIB_LIBXCOMPOSITE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXCOMPOSITE_INSTALL_STAGING = YES
XLIB_LIBXCOMPOSITE_DEPENDENCIES = xproto_compositeproto xlib_libX11 xlib_libXext xlib_libXfixes xproto_xproto

$(eval $(autotools-package))
