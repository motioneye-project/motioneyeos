################################################################################
#
# xlib_libXfixes
#
################################################################################

XLIB_LIBXFIXES_VERSION = 5.0.1
XLIB_LIBXFIXES_SOURCE = libXfixes-$(XLIB_LIBXFIXES_VERSION).tar.bz2
XLIB_LIBXFIXES_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFIXES_LICENSE = MIT
XLIB_LIBXFIXES_LICENSE_FILES = COPYING
# 0001-remove-fallback-for-xeatdatawords.patch
XLIB_LIBXFIXES_AUTORECONF = YES
XLIB_LIBXFIXES_INSTALL_STAGING = YES
XLIB_LIBXFIXES_DEPENDENCIES = xproto_fixesproto xlib_libX11 xproto_xextproto xproto_xproto

$(eval $(autotools-package))
$(eval $(host-autotools-package))
