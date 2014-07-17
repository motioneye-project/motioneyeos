################################################################################
#
# xlib_libxshmfence
#
################################################################################

XLIB_LIBXSHMFENCE_VERSION = 1.1
XLIB_LIBXSHMFENCE_SOURCE = libxshmfence-$(XLIB_LIBXSHMFENCE_VERSION).tar.bz2
XLIB_LIBXSHMFENCE_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXSHMFENCE_LICENSE = MIT
XLIB_LIBXSHMFENCE_LICENSE_FILES = COPYING
XLIB_LIBXSHMFENCE_INSTALL_STAGING = YES
XLIB_LIBXSHMFENCE_DEPENDENCIES = host-pkgconf xproto_xproto

$(eval $(autotools-package))
