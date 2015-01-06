################################################################################
#
# poppler
#
################################################################################

POPPLER_VERSION = 0.24.5
POPPLER_SOURCE = poppler-$(POPPLER_VERSION).tar.xz
POPPLER_SITE = http://poppler.freedesktop.org
POPPLER_DEPENDENCIES = fontconfig
POPPLER_LICENSE = GPLv2+
POPPLER_LICENSE_FILES = COPYING
POPPLER_INSTALL_STAGING = YES
POPPLER_CONF_OPTS = --with-font-configuration=fontconfig

ifeq ($(BR2_PACKAGE_LCMS2),y)
	POPPLER_CONF_OPTS += --enable-cms=lcms2
	POPPLER_DEPENDENCIES += lcms2
else
	POPPLER_CONF_OPTS += --enable-cms=none
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
	POPPLER_CONF_OPTS += --enable-libtiff
	POPPLER_DEPENDENCIES += tiff
else
	POPPLER_CONF_OPTS += --disable-libtiff
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
	POPPLER_CONF_OPTS += --enable-libjpeg
	POPPLER_DEPENDENCIES += jpeg
else
	POPPLER_CONF_OPTS += --disable-libjpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
	POPPLER_CONF_OPTS += --enable-libpng
	POPPLER_DEPENDENCIES += libpng
else
	POPPLER_CONF_OPTS += --disable-libpng
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
	POPPLER_CONF_OPTS += --enable-zlib
	POPPLER_DEPENDENCIES += zlib
else
	POPPLER_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_POPPLER_LIBCURL),y)
	POPPLER_CONF_OPTS += --enable-libcurl
	POPPLER_DEPENDENCIES += libcurl
else
	POPPLER_CONF_OPTS += --disable-libcurl
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
	POPPLER_CONF_OPTS += --with-x
	POPPLER_DEPENDENCIES += xlib_libX11 xlib_libXext
else
	POPPLER_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_POPPLER_QT),y)
	POPPLER_DEPENDENCIES += qt
	POPPLER_CONF_OPTS += --enable-poppler-qt4
else
	POPPLER_CONF_OPTS += --disable-poppler-qt4
endif

$(eval $(autotools-package))
