################################################################################
#
# xlib_libFS
#
################################################################################

XLIB_LIBFS_VERSION = 1.0.6
XLIB_LIBFS_SOURCE = libFS-$(XLIB_LIBFS_VERSION).tar.bz2
XLIB_LIBFS_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBFS_LICENSE = MIT
XLIB_LIBFS_LICENSE_FILES = COPYING
XLIB_LIBFS_INSTALL_STAGING = YES
XLIB_LIBFS_DEPENDENCIES = xlib_xtrans xproto_xproto xproto_fontsproto host-pkgconf
XLIB_LIBFS_CONF_OPT = --disable-malloc0returnsnull

$(eval $(autotools-package))
