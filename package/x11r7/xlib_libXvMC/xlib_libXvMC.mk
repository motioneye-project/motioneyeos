################################################################################
#
# xlib_libXvMC
#
################################################################################

XLIB_LIBXVMC_VERSION = 1.0.11
XLIB_LIBXVMC_SOURCE = libXvMC-$(XLIB_LIBXVMC_VERSION).tar.bz2
XLIB_LIBXVMC_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXVMC_LICENSE = MIT
XLIB_LIBXVMC_LICENSE_FILES = COPYING
XLIB_LIBXVMC_INSTALL_STAGING = YES
XLIB_LIBXVMC_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXv xorgproto
XLIB_LIBXVMC_CONF_OPTS = --disable-malloc0returnsnull

$(eval $(autotools-package))
