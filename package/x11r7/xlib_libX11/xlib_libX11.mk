################################################################################
#
# xlib_libX11
#
################################################################################

XLIB_LIBX11_VERSION = 1.6.5
XLIB_LIBX11_SOURCE = libX11-$(XLIB_LIBX11_VERSION).tar.bz2
XLIB_LIBX11_SITE = https://xorg.freedesktop.org/archive/individual/lib
XLIB_LIBX11_LICENSE = MIT
XLIB_LIBX11_LICENSE_FILES = COPYING
XLIB_LIBX11_INSTALL_STAGING = YES
XLIB_LIBX11_DEPENDENCIES = \
	libxcb \
	xutil_util-macros \
	xlib_xtrans \
	xlib_libXau \
	xlib_libXdmcp \
	xproto_kbproto \
	xproto_xproto \
	xproto_xextproto \
	xproto_inputproto \
	xproto_xf86bigfontproto \
	host-xproto_xproto

HOST_XLIB_LIBX11_DEPENDENCIES = \
	host-libxcb \
	host-xutil_util-macros \
	host-xlib_xtrans \
	host-xlib_libXau \
	host-xlib_libXdmcp \
	host-xproto_kbproto \
	host-xproto_xproto \
	host-xproto_xextproto \
	host-xproto_inputproto \
	host-xproto_xf86bigfontproto

XLIB_LIBX11_CONF_OPTS = \
	--disable-malloc0returnsnull \
	--with-xcb \
	--disable-specs \
	--without-perl

HOST_XLIB_LIBX11_CONF_OPTS = \
	--disable-specs \
	--without-perl

# src/util/makekeys is executed at build time to generate ks_tables.h, so
# it should get compiled for the host. The libX11 makefile unfortunately
# doesn't have X11_CFLAGS_FOR_BUILD so this doesn't work.  For buildroot,
# we know the X11 includes are in $(HOST_DIR)/include, which are already
# in the CFLAGS_FOR_BUILD, so we can just remove the X11_CFLAGS
define XLIB_LIBX11_DISABLE_MAKEKEYS_X11_CFLAGS
	$(SED) '/X11_CFLAGS/d' $(@D)/src/util/Makefile*
endef

XLIB_LIBX11_POST_PATCH_HOOKS += XLIB_LIBX11_DISABLE_MAKEKEYS_X11_CFLAGS
HOST_XLIB_LIBX11_POST_PATCH_HOOKS += XLIB_LIBX11_DISABLE_MAKEKEYS_X11_CFLAGS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
