################################################################################
#
# xlib_libX11 -- X.Org X11 library
#
################################################################################

XLIB_LIBX11_VERSION = 1.1.1
XLIB_LIBX11_SOURCE = libX11-$(XLIB_LIBX11_VERSION).tar.bz2
XLIB_LIBX11_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBX11_AUTORECONF = YES
XLIB_LIBX11_INSTALL_STAGING = YES
XLIB_LIBX11_DEPENDENCIES = libxcb xutil_util-macros xlib_xtrans xlib_libXau xlib_libXdmcp xproto_kbproto xproto_xproto xproto_xextproto xproto_inputproto xproto_xf86bigfontproto xproto_bigreqsproto xproto_xcmiscproto
XLIB_LIBX11_CONF_ENV = ac_cv_func_mmap_fixed_mapped=yes CC_FOR_BUILD="/usr/bin/gcc -I$(STAGING_DIR)/usr/include"
XLIB_LIBX11_CONF_OPT = --disable-malloc0returnsnull --with-xcb --enable-shared --disable-static

$(eval $(call AUTOTARGETS,xlib_libX11))
