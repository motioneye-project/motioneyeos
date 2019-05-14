################################################################################
#
# libvips
#
################################################################################

LIBVIPS_VERSION_MAJOR = 7.42
LIBVIPS_VERSION = $(LIBVIPS_VERSION_MAJOR).2
LIBVIPS_SOURCE = vips-$(LIBVIPS_VERSION).tar.gz
LIBVIPS_SITE = http://www.vips.ecs.soton.ac.uk/supported/$(LIBVIPS_VERSION_MAJOR)
LIBVIPS_LICENSE = LGPL-2.1+
LIBVIPS_LICENSE_FILES = COPYING
# We're patching gtk-doc.make, so need to autoreconf
LIBVIPS_AUTORECONF = YES

# Sparc64 compile fails, for all optimization levels except -O0. To
# fix the problem, use -O0 with no optimization instead. Bug reported
# upstream at https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69038.
ifeq ($(BR2_sparc64),y)
LIBVIPS_CXXFLAGS += -O0
endif

LIBVIPS_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) $(LIBVIPS_CXXFLAGS)"

LIBVIPS_CONF_OPTS = \
	--disable-introspection \
	--without-dmalloc \
	--without-gsf \
	--without-magick \
	--without-orc \
	--without-lcms \
	--without-OpenEXR \
	--without-openslide \
	--without-matio \
	--without-cfitsio \
	--without-libwebp \
	--without-pangoft2 \
	--without-x \
	--without-zip \
	--without-python
LIBVIPS_INSTALL_STAGING = YES
LIBVIPS_DEPENDENCIES = \
	host-pkgconf libglib2 \
	libxml2 $(TARGET_NLS_DEPENDENCIES)

# --disable-cxx is broken upstream
# https://github.com/jcupitt/libvips/issues/231
LIBVIPS_CONF_OPTS += --enable-cxx

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBVIPS_CONF_OPTS += --with-jpeg
LIBVIPS_DEPENDENCIES += jpeg
else
LIBVIPS_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBVIPS_CONF_OPTS += --with-png
LIBVIPS_DEPENDENCIES += libpng
else
LIBVIPS_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBVIPS_CONF_OPTS += --with-tiff
LIBVIPS_DEPENDENCIES += tiff
else
LIBVIPS_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_FFTW_DOUBLE),y)
LIBVIPS_CONF_OPTS += --with-fftw
LIBVIPS_DEPENDENCIES += fftw-double
else
LIBVIPS_CONF_OPTS += --without-fftw
endif

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBVIPS_CONF_OPTS += --with-libexif
LIBVIPS_DEPENDENCIES += libexif
else
LIBVIPS_CONF_OPTS += --without-libexif
endif

$(eval $(autotools-package))
