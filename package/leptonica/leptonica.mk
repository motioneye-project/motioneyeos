################################################################################
#
# leptonica
#
################################################################################

LEPTONICA_VERSION = 1.78.0
LEPTONICA_SITE = http://www.leptonica.org/source
LEPTONICA_LICENSE = BSD-2-Clause
LEPTONICA_LICENSE_FILES = leptonica-license.txt
LEPTONICA_INSTALL_STAGING = YES
LEPTONICA_DEPENDENCIES = host-pkgconf

LEPTONICA_CONF_OPTS += --disable-programs

ifeq ($(BR2_PACKAGE_GIFLIB),y)
LEPTONICA_DEPENDENCIES += giflib
LEPTONICA_CONF_OPTS +=  --with-giflib
else
LEPTONICA_CONF_OPTS +=  --without-giflib
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LEPTONICA_DEPENDENCIES += jpeg
LEPTONICA_CONF_OPTS += --with-jpeg
else
LEPTONICA_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LEPTONICA_DEPENDENCIES += libpng
LEPTONICA_CONF_OPTS += --with-libpng
else
LEPTONICA_CONF_OPTS += --without-libpng
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
LEPTONICA_DEPENDENCIES += openjpeg
LEPTONICA_CONF_OPTS += --with-libopenjpeg
else
LEPTONICA_CONF_OPTS += --without-libopenjpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LEPTONICA_DEPENDENCIES += tiff
LEPTONICA_CONF_OPTS += --with-libtiff
else
LEPTONICA_CONF_OPTS += --without-libtiff
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
LEPTONICA_DEPENDENCIES += webp
LEPTONICA_CONF_OPTS += --with-libwebp
else
LEPTONICA_CONF_OPTS += --without-libwebp
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LEPTONICA_DEPENDENCIES += zlib
LEPTONICA_CONF_OPTS += --with-zlib
else
LEPTONICA_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
