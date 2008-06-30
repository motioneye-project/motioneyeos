################################################################################
#
# xlib_libXt -- X.Org Xt library
#
################################################################################

XLIB_LIBXT_VERSION = 1.0.4
XLIB_LIBXT_SOURCE = libXt-$(XLIB_LIBXT_VERSION).tar.bz2
XLIB_LIBXT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXT_AUTORECONF = NO
XLIB_LIBXT_INSTALL_STAGING = YES
XLIB_LIBXT_DEPENDENCIES = xlib_libSM xlib_libX11 xproto_kbproto xproto_xproto xcb-proto libxcb
XLIB_LIBXT_CONF_ENV = CC_FOR_BUILD="/usr/bin/gcc -I$(STAGING_DIR)/usr/include"
XLIB_LIBXT_CONF_OPT = --disable-malloc0returnsnull --enable-shared --disable-static

$(eval $(call AUTOTARGETS,package/x11r7,xlib_libXt))

# the host makestrs shouldn't get installed in target
$(XLIB_LIBXT_HOOK_POST_INSTALL):
	rm -f $(TARGET_DIR)/usr/bin/makestrs
