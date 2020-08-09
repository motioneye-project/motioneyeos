################################################################################
#
# imagemagick
#
################################################################################

IMAGEMAGICK_VERSION = 7.0.8-59
IMAGEMAGICK_SOURCE = $(IMAGEMAGICK_VERSION).tar.gz
IMAGEMAGICK_SITE = https://github.com/ImageMagick/ImageMagick/archive
IMAGEMAGICK_LICENSE = Apache-2.0
IMAGEMAGICK_LICENSE_FILES = LICENSE

IMAGEMAGICK_INSTALL_STAGING = YES
IMAGEMAGICK_CONFIG_SCRIPTS = \
	$(addsuffix -config,MagickCore MagickWand)

ifeq ($(BR2_INSTALL_LIBSTDCPP)$(BR2_USE_WCHAR),yy)
IMAGEMAGICK_CONFIG_SCRIPTS += Magick++-config
endif

IMAGEMAGICK_CONF_ENV = \
	ac_cv_sys_file_offset_bits=64 \
	ax_cv_check_cl_libcl=no

IMAGEMAGICK_CONF_OPTS = \
	--program-transform-name='s,,,' \
	--disable-opencl \
	--disable-openmp \
	--without-djvu \
	--without-dps \
	--without-flif \
	--without-fpx \
	--without-gslib \
	--without-gvc \
	--without-jbig \
	--without-lqr \
	--without-openexr \
	--without-perl \
	--without-raqm \
	--without-wmf \
	--without-x \
	--with-gs-font-dir=/usr/share/fonts/gs

IMAGEMAGICK_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# Like postgreSQL, imagemagick does not build against uClibc with
# locales enabled, due to an uClibc bug, see
# http://lists.uclibc.org/pipermail/uclibc/2014-April/048326.html
# so overwrite automatic detection and disable locale support
IMAGEMAGICK_CONF_ENV += ac_cv_func_newlocale=no
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
IMAGEMAGICK_CONF_OPTS += --with-fontconfig
IMAGEMAGICK_DEPENDENCIES += fontconfig
else
IMAGEMAGICK_CONF_OPTS += --without-fontconfig
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
IMAGEMAGICK_CONF_OPTS += --with-freetype
IMAGEMAGICK_CONF_ENV += \
	ac_cv_path_freetype_config=$(STAGING_DIR)/usr/bin/freetype-config
IMAGEMAGICK_DEPENDENCIES += freetype
else
IMAGEMAGICK_CONF_OPTS += --without-freetype
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
IMAGEMAGICK_CONF_OPTS += --with-jpeg
IMAGEMAGICK_DEPENDENCIES += jpeg
else
IMAGEMAGICK_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
IMAGEMAGICK_CONF_OPTS += --with-lcms
IMAGEMAGICK_DEPENDENCIES += lcms2
else
IMAGEMAGICK_CONF_OPTS += --without-lcms
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
IMAGEMAGICK_CONF_OPTS += --with-png
IMAGEMAGICK_DEPENDENCIES += libpng
else
IMAGEMAGICK_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
IMAGEMAGICK_CONF_OPTS += --with-rsvg
IMAGEMAGICK_DEPENDENCIES += librsvg
else
IMAGEMAGICK_CONF_OPTS += --without-rsvg
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
IMAGEMAGICK_CONF_OPTS += --with-xml
IMAGEMAGICK_CONF_ENV += ac_cv_path_xml2_config=$(STAGING_DIR)/usr/bin/xml2-config
IMAGEMAGICK_DEPENDENCIES += libxml2
else
IMAGEMAGICK_CONF_OPTS += --without-xml
endif

ifeq ($(BR2_PACKAGE_PANGO),y)
IMAGEMAGICK_CONF_OPTS += --with-pango
IMAGEMAGICK_DEPENDENCIES += pango
else
IMAGEMAGICK_CONF_OPTS += --without-pango
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
IMAGEMAGICK_CONF_OPTS += --with-tiff
IMAGEMAGICK_DEPENDENCIES += tiff
else
IMAGEMAGICK_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_XZ),y)
IMAGEMAGICK_CONF_OPTS += --with-lzma
IMAGEMAGICK_DEPENDENCIES += xz
else
IMAGEMAGICK_CONF_OPTS += --without-lzma
endif

ifeq ($(BR2_PACKAGE_FFTW_DOUBLE),y)
# configure script misdetects these leading to build errors
IMAGEMAGICK_CONF_ENV += ac_cv_func_creal=yes ac_cv_func_cimag=yes
IMAGEMAGICK_CONF_OPTS += --with-fftw
IMAGEMAGICK_DEPENDENCIES += fftw-double
else
IMAGEMAGICK_CONF_OPTS += --without-fftw
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
IMAGEMAGICK_CONF_OPTS += --with-webp
IMAGEMAGICK_DEPENDENCIES += webp
else
IMAGEMAGICK_CONF_OPTS += --without-webp
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
IMAGEMAGICK_CONF_OPTS += --with-zlib
IMAGEMAGICK_DEPENDENCIES += zlib
else
IMAGEMAGICK_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
IMAGEMAGICK_CONF_OPTS += --with-bzlib
IMAGEMAGICK_DEPENDENCIES += bzip2
else
IMAGEMAGICK_CONF_OPTS += --without-bzlib
endif

HOST_IMAGEMAGICK_CONF_OPTS = \
	--disable-opencl \
	--disable-openmp \
	--without-djvu \
	--without-dps \
	--without-flif \
	--without-fpx \
	--without-gslib \
	--without-gvc \
	--without-jbig \
	--without-lqr \
	--without-openexr \
	--without-perl \
	--without-raqm \
	--without-wmf \
	--without-x \
	--without-bzlib \
	--without-fftw \
	--without-lcms \
	--without-lzma \
	--without-tiff \
	--without-webp \
	--with-jpeg \
	--with-png \
	--with-zlib

# uses clock_gettime, which was provided by librt in glibc < 2.17
HOST_IMAGEMAGICK_CONF_ENV = \
	LIBS="-lrt" \
	ax_cv_check_cl_libcl=no

HOST_IMAGEMAGICK_DEPENDENCIES = \
	host-libjpeg \
	host-libpng \
	host-pkgconf \
	host-zlib

ifeq ($(BR2_PACKAGE_HOST_IMAGEMAGICK_SVG),y)
HOST_IMAGEMAGICK_DEPENDENCIES += \
	host-fontconfig \
	host-freetype \
	host-librsvg \
	host-libxml2 \
	host-pango
HOST_IMAGEMAGICK_CONF_ENV += ac_cv_path_xml2_config=$(HOST_DIR)/bin/xml2-config
HOST_IMAGEMAGICK_CONF_OPTS += \
	--with-fontconfig \
	--with-freetype \
	--with-pango \
	--with-rsvg \
	--with-xml
else
HOST_IMAGEMAGICK_CONF_OPTS += \
	--without-fontconfig \
	--without-freetype \
	--without-pango \
	--without-rsvg \
	--without-xml
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
