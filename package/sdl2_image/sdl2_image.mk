################################################################################
#
# sdl2_image
#
################################################################################

SDL2_IMAGE_VERSION = 2.0.1
SDL2_IMAGE_SOURCE = SDL2_image-$(SDL2_IMAGE_VERSION).tar.gz
SDL2_IMAGE_SITE = http://www.libsdl.org/projects/SDL_image/release
SDL2_IMAGE_INSTALL_STAGING = YES
SDL2_IMAGE_LICENSE = zlib
SDL2_IMAGE_LICENSE_FILES = COPYING.txt

# Unconditionally enable support for image formats that don't require
# any dependency.
SDL2_IMAGE_CONF_OPTS = \
	--disable-sdltest \
	--enable-bmp \
	--enable-gif \
	--enable-lbm \
	--enable-pcx \
	--enable-pnm \
	--enable-tga \
	--enable-xcf \
	--enable-xpm \
	--enable-xv

SDL2_IMAGE_DEPENDENCIES = sdl2 host-pkgconf

ifeq ($(BR2_PACKAGE_JPEG),y)
SDL2_IMAGE_CONF_OPTS += --enable-jpg
SDL2_IMAGE_DEPENDENCIES += jpeg
else
SDL2_IMAGE_CONF_OPTS += --disable-jpg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
SDL2_IMAGE_CONF_OPTS += --enable-png
SDL2_IMAGE_DEPENDENCIES += libpng
else
SDL2_IMAGE_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
SDL2_IMAGE_CONF_OPTS += --enable-tif
SDL2_IMAGE_DEPENDENCIES += tiff
else
SDL2_IMAGE_CONF_OPTS += --disable-tif
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
SDL2_IMAGE_CONF_OPTS += --enable-webp
SDL2_IMAGE_DEPENDENCIES += webp
else
SDL2_IMAGE_CONF_OPTS += --disable-webp
endif

$(eval $(autotools-package))
