################################################################################
#
# xlib_libXfixes
#
################################################################################

XLIB_LIBXFIXES_VERSION = 5.0.3
XLIB_LIBXFIXES_SOURCE = libXfixes-$(XLIB_LIBXFIXES_VERSION).tar.bz2
XLIB_LIBXFIXES_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFIXES_LICENSE = MIT
XLIB_LIBXFIXES_LICENSE_FILES = COPYING
XLIB_LIBXFIXES_INSTALL_STAGING = YES
XLIB_LIBXFIXES_DEPENDENCIES =  xlib_libX11 xorgproto
HOST_XLIB_LIBXFIXES_DEPENDENCIES = \
	host-xlib_libX11 host-xorgproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
