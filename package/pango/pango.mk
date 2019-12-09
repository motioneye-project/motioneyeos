################################################################################
#
# pango
#
################################################################################

PANGO_VERSION_MAJOR = 1.44
PANGO_VERSION = $(PANGO_VERSION_MAJOR).6
PANGO_SOURCE = pango-$(PANGO_VERSION).tar.xz
PANGO_SITE = http://ftp.gnome.org/pub/GNOME/sources/pango/$(PANGO_VERSION_MAJOR)
PANGO_INSTALL_STAGING = YES
PANGO_LICENSE = LGPL-2.0+
PANGO_LICENSE_FILES = COPYING

PANGO_CONF_OPTS = -Duse_fontconfig=true -Dintrospection=false
HOST_PANGO_CONF_OPTS = -Duse_fontconfig=true -Dintrospection=false

PANGO_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	host-pkgconf \
	libglib2 \
	libfribidi \
	cairo \
	harfbuzz \
	fontconfig \
	freetype
HOST_PANGO_DEPENDENCIES = \
	host-pkgconf \
	host-libglib2 \
	host-libfribidi \
	host-cairo \
	host-harfbuzz \
	host-fontconfig \
	host-freetype

ifeq ($(BR2_PACKAGE_XORG7),y)
PANGO_DEPENDENCIES += xlib_libX11
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT)$(BR2_PACKAGE_XLIB_LIBXRENDER),yy)
PANGO_DEPENDENCIES += xlib_libXft xlib_libXrender
endif

$(eval $(meson-package))
$(eval $(host-meson-package))
