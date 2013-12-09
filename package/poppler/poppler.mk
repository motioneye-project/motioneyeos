################################################################################
#
# poppler
#
################################################################################

POPPLER_VERSION = 0.24.4
POPPLER_SOURCE = poppler-$(POPPLER_VERSION).tar.xz
POPPLER_SITE = http://poppler.freedesktop.org
POPPLER_DEPENDENCIES = fontconfig
POPPLER_LICENSE = GPLv2+
POPPLER_LICENSE_FILES = COPYING
POPPLER_CONF_OPT = --with-font-configuration=fontconfig

ifeq ($(BR2_PACKAGE_LCMS2),y)
	POPPLER_CONF_OPT += --enable-cms=lcms2
	POPPLER_DEPENDENCIES += lcms2
else
	POPPLER_CONF_OPT += --enable-cms=none
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
	POPPLER_CONF_OPT += --enable-libtiff
	POPPLER_DEPENDENCIES += tiff
else
	POPPLER_CONF_OPT += --disable-libtiff
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
	POPPLER_CONF_OPT += --enable-libjpeg
	POPPLER_DEPENDENCIES += jpeg
else
	POPPLER_CONF_OPT += --disable-libjpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
	POPPLER_CONF_OPT += --enable-libpng
	POPPLER_DEPENDENCIES += libpng
else
	POPPLER_CONF_OPT += --disable-libpng
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
	POPPLER_CONF_OPT += --enable-zlib
	POPPLER_DEPENDENCIES += zlib
else
	POPPLER_CONF_OPT += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_POPPLER_LIBCURL),y)
	POPPLER_CONF_OPT += --enable-libcurl
	POPPLER_DEPENDENCIES += libcurl
else
	POPPLER_CONF_OPT += --disable-libcurl
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
	POPPLER_CONF_OPT += --with-x
	POPPLER_DEPENDENCIES += xlib_libX11 xlib_libXext
else
	POPPLER_CONF_OPT += --without-x
endif

$(eval $(autotools-package))
