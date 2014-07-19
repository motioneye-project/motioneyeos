################################################################################
#
# xlib_libICE
#
################################################################################

XLIB_LIBICE_VERSION = 1.0.9
XLIB_LIBICE_SOURCE = libICE-$(XLIB_LIBICE_VERSION).tar.bz2
XLIB_LIBICE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBICE_LICENSE = MIT
XLIB_LIBICE_LICENSE_FILES = COPYING
XLIB_LIBICE_INSTALL_STAGING = YES
XLIB_LIBICE_DEPENDENCIES = xlib_xtrans xproto_xproto

$(eval $(autotools-package))
