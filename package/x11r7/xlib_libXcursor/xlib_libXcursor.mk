################################################################################
#
# xlib_libXcursor
#
################################################################################

XLIB_LIBXCURSOR_VERSION = 1.1.13
XLIB_LIBXCURSOR_SOURCE = libXcursor-$(XLIB_LIBXCURSOR_VERSION).tar.bz2
XLIB_LIBXCURSOR_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXCURSOR_LICENSE = MIT
XLIB_LIBXCURSOR_LICENSE_FILES = COPYING
XLIB_LIBXCURSOR_INSTALL_STAGING = YES
XLIB_LIBXCURSOR_DEPENDENCIES = xlib_libX11 xlib_libXfixes xlib_libXrender xproto_xproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
