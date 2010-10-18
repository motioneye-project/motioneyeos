#############################################################
#
# gdk-pixbuf
#
#############################################################

GDK_PIXBUF_MAJOR_VERSION = 2.22
GDK_PIXBUF_VERSION = $(GDK_PIXBUF_MAJOR_VERSION).0
GDK_PIXBUF_SOURCE = gdk-pixbuf-$(GDK_PIXBUF_VERSION).tar.bz2
GDK_PIXBUF_SITE = http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/$(GDK_PIXBUF_MAJOR_VERSION)
GDK_PIXBUF_INSTALL_STAGING = YES

GDK_PIXBUF_CONF_ENV = \
	ac_cv_path_GLIB_GENMARSHAL=$(LIBGLIB2_HOST_BINARY) \
	gio_can_sniff=no

GDK_PIXBUF_CONF_OPT = --disable-glibtest

ifneq ($(BR2_LARGEFILE),y)
GDK_PIXBUF_CONF_OPT += --disable-largefile
endif

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

GDK_PIXBUF_DEPENDENCIES += $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl) host-pkg-config libglib2 libiconv

$(eval $(call AUTOTARGETS,package,gdk-pixbuf))

HOST_GDK_PIXBUF_CONF_OPT = \
	--without-libjpeg \
	--without-libtiff

HOST_GDK_PIXBUF_DEPENDENCIES = host-libpng

$(eval $(call AUTOTARGETS,package,gdk-pixbuf,host))
