################################################################################
#
# pango
#
################################################################################

PANGO_VERSION_MAJOR = 1.40
PANGO_VERSION = $(PANGO_VERSION_MAJOR).1
PANGO_SOURCE = pango-$(PANGO_VERSION).tar.xz
PANGO_SITE = http://ftp.gnome.org/pub/GNOME/sources/pango/$(PANGO_VERSION_MAJOR)
PANGO_AUTORECONF = YES
PANGO_INSTALL_STAGING = YES
PANGO_LICENSE = LGPLv2+
PANGO_LICENSE_FILES = COPYING

PANGO_CONF_OPTS = --enable-explicit-deps=no
HOST_PANGO_CONF_OPTS = --enable-explicit-deps=no

PANGO_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	host-pkgconf \
	libglib2 \
	cairo \
	harfbuzz \
	fontconfig \
	freetype
HOST_PANGO_DEPENDENCIES = \
	host-pkgconf \
	host-libglib2 \
	host-cairo \
	host-harfbuzz \
	host-fontconfig \
	host-freetype

ifeq ($(BR2_PACKAGE_XORG7),y)
PANGO_CONF_OPTS += \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib
PANGO_DEPENDENCIES += xlib_libX11
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT)$(BR2_PACKAGE_XLIB_LIBXRENDER),yy)
PANGO_DEPENDENCIES += xlib_libXft xlib_libXrender
PANGO_CONF_OPTS += --with-xft
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
