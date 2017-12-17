################################################################################
#
# xlib_libXau
#
################################################################################

XLIB_LIBXAU_VERSION = 1.0.8
XLIB_LIBXAU_SOURCE = libXau-$(XLIB_LIBXAU_VERSION).tar.bz2
XLIB_LIBXAU_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXAU_LICENSE = MIT
XLIB_LIBXAU_LICENSE_FILES = COPYING
XLIB_LIBXAU_INSTALL_STAGING = YES
XLIB_LIBXAU_DEPENDENCIES = host-pkgconf xutil_util-macros xproto_xproto
HOST_XLIB_LIBXAU_DEPENDENCIES = \
	host-pkgconf host-xutil_util-macros host-xproto_xproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
