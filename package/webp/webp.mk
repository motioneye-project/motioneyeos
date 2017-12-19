################################################################################
#
# webp
#
################################################################################

WEBP_VERSION = 0.6.1
WEBP_SOURCE = libwebp-$(WEBP_VERSION).tar.gz
WEBP_SITE = http://downloads.webmproject.org/releases/webp
WEBP_LICENSE = BSD-3-Clause
WEBP_LICENSE_FILES = COPYING
WEBP_INSTALL_STAGING = YES

WEBP_CONF_OPTS += \
	--with-jpegincludedir=$(STAGING_DIR)/usr/include \
	--with-jpeglibdir=$(STAGING_DIR)/usr/lib \
	--with-tiffincludedir=$(STAGING_DIR)/usr/include \
	--with-tifflibdir=$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_WEBP_DEMUX),y)
WEBP_CONF_OPTS += --enable-libwebpdemux
else
WEBP_CONF_OPTS += --disable-libwebpdemux
endif

ifeq ($(BR2_PACKAGE_WEBP_MUX),y)
WEBP_CONF_OPTS += --enable-libwebpmux
else
WEBP_CONF_OPTS += --disable-libwebpmux
endif

ifeq ($(BR2_PACKAGE_GIFLIB),y)
WEBP_DEPENDENCIES += giflib
WEBP_CONF_OPTS += --enable-gif
else
WEBP_CONF_OPTS += --disable-gif
endif

ifeq ($(BR2_PACKAGE_LIBFREEGLUT),y)
WEBP_DEPENDENCIES += libfreeglut
WEBP_CONF_OPTS += --enable-gl
else
WEBP_CONF_OPTS += --disable-gl
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
WEBP_DEPENDENCIES += libpng
WEBP_CONF_ENV += ac_cv_path_LIBPNG_CONFIG=$(STAGING_DIR)/usr/bin/libpng-config
else
WEBP_CONF_ENV += ac_cv_path_LIBPNG_CONFIG=/bin/false
endif

WEBP_DEPENDENCIES += $(if $(BR2_PACKAGE_JPEG),jpeg)
WEBP_DEPENDENCIES += $(if $(BR2_PACKAGE_TIFF),tiff)

$(eval $(autotools-package))
