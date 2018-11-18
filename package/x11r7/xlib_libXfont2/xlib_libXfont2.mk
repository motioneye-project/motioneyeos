################################################################################
#
# xlib_libXfont2
#
################################################################################

XLIB_LIBXFONT2_VERSION = 2.0.3
XLIB_LIBXFONT2_SOURCE = libXfont2-$(XLIB_LIBXFONT2_VERSION).tar.bz2
XLIB_LIBXFONT2_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFONT2_LICENSE = MIT
XLIB_LIBXFONT2_LICENSE_FILES = COPYING
XLIB_LIBXFONT2_INSTALL_STAGING = YES
XLIB_LIBXFONT2_DEPENDENCIES = \
	freetype \
	xlib_libfontenc \
	xlib_xtrans \
	xorgproto \
	xfont_encodings

HOST_XLIB_LIBXFONT2_DEPENDENCIES = \
	host-freetype \
	host-xlib_libfontenc \
	host-xlib_xtrans \
	host-xorgproto \
	host-xfont_encodings

XLIB_LIBXFONT2_CONF_OPTS = --disable-devel-docs
HOST_XLIB_LIBXFONT2_CONF_OPTS = --disable-devel-docs

$(eval $(autotools-package))
$(eval $(host-autotools-package))
