################################################################################
#
# xlib_libpciaccess -- X.Org pciaccess library
#
################################################################################

XLIB_LIBPCIACCESS_VERSION = 0.12.1
XLIB_LIBPCIACCESS_SOURCE = libpciaccess-$(XLIB_LIBPCIACCESS_VERSION).tar.bz2
XLIB_LIBPCIACCESS_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBPCIACCESS_INSTALL_STAGING = YES

$(eval $(autotools-package))
