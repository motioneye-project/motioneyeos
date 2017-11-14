################################################################################
#
# libgdiplus
#
################################################################################

LIBGDIPLUS_VERSION = 5.4
LIBGDIPLUS_SITE = $(call github,mono,libgdiplus,$(LIBGDIPLUS_VERSION))

# Although there is a LICENSE file thas specifies LGPL or MPL-1.1,
# looks like it is incorrect. The actual source files specify that
# they're licensed under MIT, and so does the COPYING file (and they
# all predate the addition of the LICENSE file).
LIBGDIPLUS_LICENSE = MIT
LIBGDIPLUS_LICENSE_FILES = COPYING src/carbon-private.h

LIBGDIPLUS_INSTALL_STAGING = YES

# github tarball doesn't have configure
LIBGDIPLUS_AUTORECONF = YES

LIBGDIPLUS_DEPENDENCIES = xlib_libXft libglib2 cairo libpng host-pkgconf

ifeq ($(BR2_PACKAGE_GIFLIB),y)
LIBGDIPLUS_CONF_OPTS += --with-libgif
LIBGDIPLUS_DEPENDENCIES += giflib
else
LIBGDIPLUS_CONF_OPTS += --without-libgif
endif

# there is a bug in the configure script that enables pango support
# when passing --without-pango, so let's just not use it
ifeq ($(BR2_PACKAGE_PANGO),y)
LIBGDIPLUS_CONF_OPTS += --with-pango
LIBGDIPLUS_DEPENDENCIES += pango
endif

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBGDIPLUS_CONF_OPTS += --with-libexif
LIBGDIPLUS_DEPENDENCIES += libexif
else
LIBGDIPLUS_CONF_OPTS += --without-libexif
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBGDIPLUS_CONF_OPTS += --with-libjpeg=$(STAGING_DIR)/usr
LIBGDIPLUS_DEPENDENCIES += jpeg
else
LIBGDIPLUS_CONF_OPTS += --without-libjpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBGDIPLUS_CONF_OPTS += --with-libtiff=$(STAGING_DIR)/usr
LIBGDIPLUS_DEPENDENCIES += tiff
else
LIBGDIPLUS_CONF_OPTS += --without-libtiff
endif

$(eval $(autotools-package))
