################################################################################
#
# xlib_libFS -- X.Org FS library
#
################################################################################

XLIB_LIBFS_VERSION = 1.0.0
XLIB_LIBFS_SOURCE = libFS-$(XLIB_LIBFS_VERSION).tar.bz2
XLIB_LIBFS_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBFS_AUTORECONF = YES
XLIB_LIBFS_INSTALL_STAGING = YES
XLIB_LIBFS_DEPENDANCIES = xlib_xtrans xproto_xproto xproto_fontsproto
XLIB_LIBFS_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libFS))
