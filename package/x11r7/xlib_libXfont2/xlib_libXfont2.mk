################################################################################
#
# xlib_libXfont2
#
################################################################################

XLIB_LIBXFONT2_VERSION = 2.0.4
XLIB_LIBXFONT2_SOURCE = libXfont2-$(XLIB_LIBXFONT2_VERSION).tar.bz2
XLIB_LIBXFONT2_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFONT2_LICENSE = MIT
XLIB_LIBXFONT2_LICENSE_FILES = COPYING
XLIB_LIBXFONT2_INSTALL_STAGING = YES
# 0001-configure-define-HAVE_LIBBSD-when-libbsd-was-found.patch
XLIB_LIBXFONT2_AUTORECONF = YES
XLIB_LIBXFONT2_DEPENDENCIES = \
	freetype \
	xlib_libfontenc \
	xlib_xtrans \
	xorgproto \
	xfont_encodings

ifeq ($(BR2_PACKAGE_LIBBSD),y)
XLIB_LIBXFONT2_DEPENDENCIES += libbsd
endif

HOST_XLIB_LIBXFONT2_DEPENDENCIES = \
	host-freetype \
	host-xlib_libfontenc \
	host-xlib_xtrans \
	host-xorgproto \
	host-xfont_encodings

XLIB_LIBXFONT2_CONF_OPTS = --disable-devel-docs
HOST_XLIB_LIBXFONT2_CONF_OPTS = --disable-devel-docs

XLIB_LIBXFONT2_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
XLIB_LIBXFONT2_CFLAGS += -O0
endif

XLIB_LIBXFONT2_CONF_ENV = CFLAGS="$(XLIB_LIBXFONT2_CFLAGS)"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
