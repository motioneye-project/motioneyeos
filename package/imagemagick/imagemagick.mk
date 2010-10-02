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

IMAGEMAGICK_DEPENDENCIES = jpeg tiff

ifeq ($(BR2_LARGEFILE),y)
IMAGEMAGICK_CONF_ENV = ac_cv_sys_file_offset_bits=64
else
IMAGEMAGICK_CONF_ENV = ac_cv_sys_file_offset_bits=32
endif

IMAGEMAGICK_CONF_OPT = --program-transform-name='s,,,' \
		--without-perl \
		--without-wmf \
		--without-xml \
		--without-rsvg \
		--without-openexr \
		--without-jp2 \
		--without-jbig \
		--without-gvc \
		--without-djvu \
		--without-dps \
		--without-gslib \
		--without-fpx \
		--without-freetype \
		--without-x

$(eval $(call AUTOTARGETS,package,imagemagick))
