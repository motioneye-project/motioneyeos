################################################################################
#
# xlib_libXft
#
################################################################################

XLIB_LIBXFT_VERSION = 2.3.2
XLIB_LIBXFT_SOURCE = libXft-$(XLIB_LIBXFT_VERSION).tar.bz2
XLIB_LIBXFT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFT_LICENSE = MIT
XLIB_LIBXFT_LICENSE_FILES = COPYING
XLIB_LIBXFT_INSTALL_STAGING = YES
XLIB_LIBXFT_DEPENDENCIES = fontconfig freetype xlib_libX11 xlib_libXext xlib_libXrender xorgproto

$(eval $(autotools-package))
