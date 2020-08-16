################################################################################
#
# xlib_libICE
#
################################################################################

XLIB_LIBICE_VERSION = 1.0.10
XLIB_LIBICE_SOURCE = libICE-$(XLIB_LIBICE_VERSION).tar.bz2
XLIB_LIBICE_SITE = https://xorg.freedesktop.org/archive/individual/lib
XLIB_LIBICE_LICENSE = MIT
XLIB_LIBICE_LICENSE_FILES = COPYING
XLIB_LIBICE_INSTALL_STAGING = YES
XLIB_LIBICE_DEPENDENCIES = xlib_xtrans xorgproto host-pkgconf

$(eval $(autotools-package))
