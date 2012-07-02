################################################################################
#
# xlib_libX11 -- X.Org X11 library
#
################################################################################

XLIB_LIBX11_VERSION = 1.3.2
XLIB_LIBX11_SOURCE = libX11-$(XLIB_LIBX11_VERSION).tar.bz2
XLIB_LIBX11_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBX11_AUTORECONF = YES
XLIB_LIBX11_INSTALL_STAGING = YES
XLIB_LIBX11_DEPENDENCIES = libxcb xutil_util-macros xlib_xtrans xlib_libXau xlib_libXdmcp xproto_kbproto xproto_xproto xproto_xextproto xproto_inputproto xproto_xf86bigfontproto xproto_xcmiscproto host-xproto_xproto
XLIB_LIBX11_CONF_OPT = \
	--disable-malloc0returnsnull \
	--with-xcb \
	--with-keysymdef=$(STAGING_DIR)/usr/include/X11/keysymdef.h \
	--disable-specs

HOST_XLIB_LIBX11_CONF_OPT = \
	--disable-specs

# src/util/makekeys is executed at build time to generate ks_tables.h, so
# it should get compiled for the host. The libX11 makefile unfortunately
# doesn't know about cross compilation so this doesn't work.
# Long term, we should probably teach it about HOSTCC / HOST_CFLAGS, but for
# now simply disable the src/util Makefile and build makekeys by hand in
# advance
define XLIB_LIBX11_DISABLE_MAKEKEYS_BUILD
	echo '' > $(@D)/src/util/Makefile.am
endef

XLIB_LIBX11_POST_EXTRACT_HOOKS += XLIB_LIBX11_DISABLE_MAKEKEYS_BUILD

define XLIB_LIBX11_BUILD_MAKEKEYS_FOR_HOST
	cd $(@D)/src/util && $(HOSTCC) $(HOST_CFLAGS) -o makekeys makekeys.c
endef

XLIB_LIBX11_POST_CONFIGURE_HOOKS += XLIB_LIBX11_BUILD_MAKEKEYS_FOR_HOST

$(eval $(autotools-package))
$(eval $(host-autotools-package))
