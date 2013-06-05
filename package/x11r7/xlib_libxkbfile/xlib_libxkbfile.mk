################################################################################
#
# xlib_libxkbfile
#
################################################################################

XLIB_LIBXKBFILE_VERSION = 1.0.8
XLIB_LIBXKBFILE_SOURCE = libxkbfile-$(XLIB_LIBXKBFILE_VERSION).tar.bz2
XLIB_LIBXKBFILE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXKBFILE_LICENSE = MIT
XLIB_LIBXKBFILE_LICENSE_FILES = COPYING
XLIB_LIBXKBFILE_INSTALL_STAGING = YES
XLIB_LIBXKBFILE_DEPENDENCIES = xlib_libX11 xproto_kbproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
