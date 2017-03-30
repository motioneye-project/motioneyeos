################################################################################
#
# libmediaart
#
################################################################################

LIBMEDIAART_VERSION_MAJOR = 1.9
LIBMEDIAART_VERSION = $(LIBMEDIAART_VERSION_MAJOR).1
LIBMEDIAART_SOURCE = libmediaart-$(LIBMEDIAART_VERSION).tar.xz
LIBMEDIAART_SITE = \
	http://ftp.gnome.org/pub/gnome/sources/libmediaart/$(LIBMEDIAART_VERSION_MAJOR)
LIBMEDIAART_LICENSE = LGPL-2.1+
LIBMEDIAART_LICENSE_FILES = COPYING.LESSER
LIBMEDIAART_INSTALL_STAGING = YES
LIBMEDIAART_DEPENDENCIES = libglib2
LIBMEDIAART_CONF_OPTS = --disable-unit-tests

ifeq ($(BR2_PACKAGE_MEDIAART_BACKEND_GDK_PIXBUF),y)
LIBMEDIAART_DEPENDENCIES += gdk-pixbuf
LIBMEDIAART_CONF_OPTS += \
	--enable-gdkpixbuf \
	--disable-qt
else ifeq ($(BR2_PACKAGE_MEDIAART_BACKEND_QT),y)
# qt5 needs c++11 (since qt-5.7)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
LIBMEDIAART_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"
endif
LIBMEDIAART_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_QT),qt) \
	$(if $(BR2_PACKAGE_QT5),qt5base)
LIBMEDIAART_CONF_OPTS += \
	--disable-gdkpixbuf \
	--enable-qt
else ifeq ($(BR2_PACKAGE_MEDIAART_BACKEND_NONE),y)
LIBMEDIAART_CONF_OPTS += \
	--disable-gdkpixbuf \
	--disable-qt
endif

$(eval $(autotools-package))
