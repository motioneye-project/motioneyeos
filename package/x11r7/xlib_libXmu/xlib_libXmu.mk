################################################################################
#
# xlib_libXmu
#
################################################################################

XLIB_LIBXMU_VERSION = 1.1.3
XLIB_LIBXMU_SOURCE = libXmu-$(XLIB_LIBXMU_VERSION).tar.bz2
XLIB_LIBXMU_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXMU_LICENSE = MIT
XLIB_LIBXMU_LICENSE_FILES = COPYING
XLIB_LIBXMU_INSTALL_STAGING = YES
XLIB_LIBXMU_DEPENDENCIES = xlib_libX11 xlib_libXext xlib_libXt xorgproto

$(eval $(autotools-package))
