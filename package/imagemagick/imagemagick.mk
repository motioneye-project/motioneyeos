################################################################################
#
# imagemagick
#
################################################################################

IMAGEMAGICK_MAJOR = 6.8.7
IMAGEMAGICK_VERSION = $(IMAGEMAGICK_MAJOR)-0
IMAGEMAGICK_SOURCE = ImageMagick-$(IMAGEMAGICK_VERSION).tar.bz2
# The official ImageMagick site only keeps the latest versions
# available, which is annoying. Use an alternate site that keeps all
# older versions.
IMAGEMAGICK_SITE = ftp://ftp.nluug.nl/pub/ImageMagick/
IMAGEMAGICK_LICENSE = Apache-v2
IMAGEMAGICK_LICENSE_FILES = LICENSE

IMAGEMAGICK_INSTALL_STAGING = YES
IMAGEMAGICK_AUTORECONF = YES
IMAGEMAGICK_CONFIG_SCRIPTS = \
	$(addsuffix -config,Magick MagickCore MagickWand Wand)

ifeq ($(BR2_INSTALL_LIBSTDCPP)$(BR2_USE_WCHAR),yy)
IMAGEMAGICK_CONFIG_SCRIPTS += Magick++-config
endif

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

IMAGEMAGICK_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
IMAGEMAGICK_CONF_OPT += --with-fontconfig
IMAGEMAGICK_DEPENDENCIES += fontconfig
else
IMAGEMAGICK_CONF_OPT += --without-fontconfig
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
IMAGEMAGICK_CONF_OPT += --with-freetype
IMAGEMAGICK_CONF_ENV += \
	ac_cv_path_freetype_config=$(STAGING_DIR)/usr/bin/freetype-config
IMAGEMAGICK_DEPENDENCIES += freetype
else
IMAGEMAGICK_CONF_OPT += --without-freetype
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
IMAGEMAGICK_CONF_OPT += --with-jpeg
IMAGEMAGICK_DEPENDENCIES += jpeg
else
IMAGEMAGICK_CONF_OPT += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
IMAGEMAGICK_CONF_OPT += --with-png
IMAGEMAGICK_DEPENDENCIES += libpng
else
IMAGEMAGICK_CONF_OPT += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
IMAGEMAGICK_CONF_OPT += --with-rsvg
IMAGEMAGICK_DEPENDENCIES += librsvg
else
IMAGEMAGICK_CONF_OPT += --without-rsvg
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
IMAGEMAGICK_CONF_OPT += --with-xml
IMAGEMAGICK_CONF_ENV += ac_cv_path_xml2_config=$(STAGING_DIR)/usr/bin/xml2-config
IMAGEMAGICK_DEPENDENCIES += libxml2
else
IMAGEMAGICK_CONF_OPT += --without-xml
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
IMAGEMAGICK_CONF_OPT += --with-tiff
IMAGEMAGICK_DEPENDENCIES += tiff
else
IMAGEMAGICK_CONF_OPT += --without-tiff
endif

ifeq ($(BR2_PACKAGE_FFTW),y)
# configure script misdetects these leading to build errors
IMAGEMAGICK_CONF_ENV += ac_cv_func_creal=yes ac_cv_func_cimag=yes
IMAGEMAGICK_CONF_OPT += --with-fftw
IMAGEMAGICK_DEPENDENCIES += fftw
else
IMAGEMAGICK_CONF_OPT += --without-fftw
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
IMAGEMAGICK_CONF_OPT += --with-zlib
IMAGEMAGICK_DEPENDENCIES += zlib
else
IMAGEMAGICK_CONF_OPT += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
IMAGEMAGICK_CONF_OPT += --with-bzlib
IMAGEMAGICK_DEPENDENCIES += bzip2
else
IMAGEMAGICK_CONF_OPT += --without-bzip2
endif

$(eval $(autotools-package))
