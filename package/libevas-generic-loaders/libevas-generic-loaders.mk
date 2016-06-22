################################################################################
#
# libevas-generic-loaders
#
################################################################################

LIBEVAS_GENERIC_LOADERS_VERSION = 1.17.0
LIBEVAS_GENERIC_LOADERS_SOURCE = evas_generic_loaders-$(LIBEVAS_GENERIC_LOADERS_VERSION).tar.xz
LIBEVAS_GENERIC_LOADERS_SITE = http://download.enlightenment.org/rel/libs/evas_generic_loaders
LIBEVAS_GENERIC_LOADERS_LICENSE = GPLv2
LIBEVAS_GENERIC_LOADERS_LICENSE_FILES = COPYING

LIBEVAS_GENERIC_LOADERS_INSTALL_STAGING = YES

LIBEVAS_GENERIC_LOADERS_DEPENDENCIES = host-pkgconf efl zlib

# poppler >= 0.32 is not supported by the current version of
# libevas-generic-loaders.
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += \
	--disable-poppler \
	--disable-spectre \
	--disable-gstreamer

ifeq ($(BR2_PACKAGE_LIBEVAS_GENERIC_LOADERS_LIBRAW),y)
LIBEVAS_GENERIC_LOADERS_DEPENDENCIES += libraw
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += --enable-libraw
else
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += --disable-libraw
endif

ifeq ($(BR2_PACKAGE_LIBEVAS_GENERIC_LOADERS_SVG),y)
LIBEVAS_GENERIC_LOADERS_DEPENDENCIES += librsvg cairo
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += --enable-svg
else
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += --disable-svg
endif

$(eval $(autotools-package))
