#############################################################
#
# imagemagick
#
#############################################################
IMAGEMAGICK_MAJOR = 6.6.4
IMAGEMAGICK_VERSION = $(IMAGEMAGICK_MAJOR)-8
IMAGEMAGICK_SOURCE = ImageMagick-$(IMAGEMAGICK_VERSION).tar.bz2
IMAGEMAGICK_SITE = ftp://ftp.imagemagick.org/pub/ImageMagick
IMAGEMAGICK_LIBTOOL_PATCH = NO
IMAGEMAGICK_INSTALL_STAGING = YES

ifeq ($(BR2_LARGEFILE),y)
IMAGEMAGICK_CONF_ENV = ac_cv_sys_file_offset_bits=64
else
IMAGEMAGICK_CONF_ENV = ac_cv_sys_file_offset_bits=32
endif

IMAGEMAGICK_CONF_OPT = --program-transform-name='s,,,' \
		--without-perl \
		--without-wmf \
		--without-openexr \
		--without-jp2 \
		--without-jbig \
		--without-gvc \
		--without-djvu \
		--without-dps \
		--without-gslib \
		--without-fpx \
		--without-x

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
IMAGEMAGICK_CONF_OPT += --with-fontconfig
IMAGEMAGICK_DEPENDENCIES += fontconfig
else
IMAGEMAGISK_CONF_OPT += --without-fontconfig
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
IMAGEMAGICK_CONF_OPT += --with-freetype
IMAGEMAGICK_DEPENDENCIES += freetype
else
IMAGEMAGISK_CONF_OPT += --without-freetype
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
IMAGEMAGICK_CONF_OPT += --with-jpeg
IMAGEMAGICK_DEPENDENCIES += jpeg
else
IMAGEMAGISK_CONF_OPT += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
IMAGEMAGICK_CONF_OPT += --with-png
IMAGEMAGICK_DEPENDENCIES += libpng
else
IMAGEMAGISK_CONF_OPT += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
IMAGEMAGICK_CONF_OPT += --with-rsvg
IMAGEMAGICK_DEPENDENCIES += librsvg
else
IMAGEMAGISK_CONF_OPT += --without-rsvg
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
IMAGEMAGICK_CONF_OPT += --with-xml
IMAGEMAGICK_DEPENDENCIES += libxml2
else
IMAGEMAGISK_CONF_OPT += --without-xml
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
IMAGEMAGICK_CONF_OPT += --with-tiff
IMAGEMAGICK_DEPENDENCIES += tiff
else
IMAGEMAGISK_CONF_OPT += --without-tiff
endif

$(eval $(call AUTOTARGETS,package,imagemagick))
