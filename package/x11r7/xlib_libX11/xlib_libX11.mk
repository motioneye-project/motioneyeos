################################################################################
#
# xlib_libX11
#
################################################################################

XLIB_LIBX11_VERSION = 1.6.8
XLIB_LIBX11_SOURCE = libX11-$(XLIB_LIBX11_VERSION).tar.bz2
XLIB_LIBX11_SITE = https://xorg.freedesktop.org/archive/individual/lib
XLIB_LIBX11_LICENSE = MIT
XLIB_LIBX11_LICENSE_FILES = COPYING
XLIB_LIBX11_INSTALL_STAGING = YES
XLIB_LIBX11_AUTORECONF = YES
XLIB_LIBX11_DEPENDENCIES = \
	libxcb \
	xutil_util-macros \
	xlib_xtrans \
	xlib_libXau \
	xlib_libXdmcp \
	xorgproto \
	host-xorgproto

HOST_XLIB_LIBX11_DEPENDENCIES = \
	host-libxcb \
	host-xutil_util-macros \
	host-xlib_xtrans \
	host-xlib_libXau \
	host-xlib_libXdmcp \
	host-xorgproto

XLIB_LIBX11_CONF_OPTS = \
	--disable-malloc0returnsnull \
	--disable-specs \
	--without-perl

HOST_XLIB_LIBX11_CONF_OPTS = \
	--disable-specs \
	--without-perl

$(eval $(autotools-package))
$(eval $(host-autotools-package))
