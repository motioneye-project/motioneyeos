################################################################################
#
# gdk-pixbuf
#
################################################################################

GDK_PIXBUF_MAJOR_VERSION = 2.28
GDK_PIXBUF_VERSION = $(GDK_PIXBUF_MAJOR_VERSION).1
GDK_PIXBUF_SOURCE = gdk-pixbuf-$(GDK_PIXBUF_VERSION).tar.xz
GDK_PIXBUF_SITE = http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/$(GDK_PIXBUF_MAJOR_VERSION)
GDK_PIXBUF_LICENSE = LGPLv2+
GDK_PIXBUF_LICENSE_FILES = COPYING
GDK_PIXBUF_INSTALL_STAGING = YES

GDK_PIXBUF_CONF_ENV = \
	ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY) \
	gio_can_sniff=no

GDK_PIXBUF_CONF_OPT = --disable-glibtest

ifneq ($(BR2_PACKAGE_LIBPNG),y)
GDK_PIXBUF_CONF_OPT += --without-libpng
else
GDK_PIXBUF_DEPENDENCIES += libpng
endif

ifneq ($(BR2_PACKAGE_JPEG),y)
GDK_PIXBUF_CONF_OPT += --without-libjpeg
else
GDK_PIXBUF_DEPENDENCIES += jpeg
endif

ifneq ($(BR2_PACKAGE_TIFF),y)
GDK_PIXBUF_CONF_OPT += --without-libtiff
else
GDK_PIXBUF_DEPENDENCIES += tiff
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
GDK_PIXBUF_CONF_OPT += --with-x11
GDK_PIXBUF_DEPENDENCIES += xlib_libX11
endif

GDK_PIXBUF_DEPENDENCIES += \
	$(if $(BR2_ENABLE_LOCALE),,libiconv) \
	host-pkgconf libglib2

define GDK_PIXBUF_POST_INSTALL_TWEAKS
	$(INSTALL) -m 755 -D package/gdk-pixbuf/S26gdk-pixbuf \
		$(TARGET_DIR)/etc/init.d/S26gdk-pixbuf
endef

GDK_PIXBUF_POST_INSTALL_TARGET_HOOKS += GDK_PIXBUF_POST_INSTALL_TWEAKS

$(eval $(autotools-package))

HOST_GDK_PIXBUF_CONF_OPT = \
	--without-libjpeg \
	--without-libtiff

HOST_GDK_PIXBUF_DEPENDENCIES = host-libpng

$(eval $(host-autotools-package))
