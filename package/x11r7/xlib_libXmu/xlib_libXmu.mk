################################################################################
#
# xlib_libXmu -- X.Org Xmu library
#
################################################################################

XLIB_LIBXMU_VERSION = 1.0.5
XLIB_LIBXMU_SOURCE = libXmu-$(XLIB_LIBXMU_VERSION).tar.bz2
XLIB_LIBXMU_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXMU_INSTALL_STAGING = YES
XLIB_LIBXMU_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXt xproto_xproto

$(eval $(autotools-package))
