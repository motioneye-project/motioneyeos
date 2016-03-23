################################################################################
#
# gdk-pixbuf
#
################################################################################

GDK_PIXBUF_VERSION_MAJOR = 2.32
GDK_PIXBUF_VERSION = $(GDK_PIXBUF_VERSION_MAJOR).3
GDK_PIXBUF_SOURCE = gdk-pixbuf-$(GDK_PIXBUF_VERSION).tar.xz
GDK_PIXBUF_SITE = http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/$(GDK_PIXBUF_VERSION_MAJOR)
GDK_PIXBUF_LICENSE = LGPLv2+
GDK_PIXBUF_LICENSE_FILES = COPYING
GDK_PIXBUF_INSTALL_STAGING = YES
GDK_PIXBUF_DEPENDENCIES = \
	host-gdk-pixbuf host-libglib2 host-pkgconf \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

GDK_PIXBUF_CONF_ENV = \
	ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY) \
	gio_can_sniff=no

GDK_PIXBUF_CONF_OPTS = --disable-glibtest

ifneq ($(BR2_PACKAGE_LIBPNG),y)
GDK_PIXBUF_CONF_OPTS += --without-libpng
else
GDK_PIXBUF_DEPENDENCIES += libpng
endif

ifneq ($(BR2_PACKAGE_JPEG),y)
GDK_PIXBUF_CONF_OPTS += --without-libjpeg
else
GDK_PIXBUF_DEPENDENCIES += jpeg
endif

ifneq ($(BR2_PACKAGE_TIFF),y)
GDK_PIXBUF_CONF_OPTS += --without-libtiff
else
GDK_PIXBUF_DEPENDENCIES += tiff host-pkgconf
GDK_PIXBUF_CONF_ENV += \
	LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libtiff-4`"
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
GDK_PIXBUF_CONF_OPTS += --with-x11
GDK_PIXBUF_DEPENDENCIES += xlib_libX11
endif

# gdk-pixbuf requires the loaders.cache file populated to work properly
# Rather than doing so at runtime, since the fs can be read-only, do so
# here after building and installing to target.
# And since the cache file will contain absolute target directory names
# we need to sanitize (strip) them.
define GDK_PIXBUF_UPDATE_CACHE
	GDK_PIXBUF_MODULEDIR=$(TARGET_DIR)/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders \
		$(HOST_DIR)/usr/bin/gdk-pixbuf-query-loaders \
		> $(TARGET_DIR)/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
	$(SED) "s,$(TARGET_DIR),,g" \
		$(TARGET_DIR)/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
endef
GDK_PIXBUF_POST_INSTALL_TARGET_HOOKS += GDK_PIXBUF_UPDATE_CACHE

# Tests don't build correctly with uClibc
define GDK_PIXBUF_DISABLE_TESTS
	$(SED) 's/ tests//' $(@D)/Makefile.in
endef
GDK_PIXBUF_POST_PATCH_HOOKS += GDK_PIXBUF_DISABLE_TESTS

$(eval $(autotools-package))

HOST_GDK_PIXBUF_CONF_OPTS = \
	--without-libjpeg \
	--without-libtiff

HOST_GDK_PIXBUF_DEPENDENCIES = host-libpng host-pkgconf host-libglib2

$(eval $(host-autotools-package))
