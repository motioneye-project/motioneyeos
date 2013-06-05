################################################################################
#
# xlib_libpciaccess
#
################################################################################

XLIB_LIBPCIACCESS_VERSION = 0.13.1
XLIB_LIBPCIACCESS_SOURCE = libpciaccess-$(XLIB_LIBPCIACCESS_VERSION).tar.bz2
XLIB_LIBPCIACCESS_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBPCIACCESS_LICENSE = MIT
XLIB_LIBPCIACCESS_LICENSE_FILES = COPYING
XLIB_LIBPCIACCESS_INSTALL_STAGING = YES

$(eval $(autotools-package))
