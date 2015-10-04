################################################################################
#
# libevas-generic-loaders
#
################################################################################

LIBEVAS_GENERIC_LOADERS_VERSION = $(EFL_VERSION)
LIBEVAS_GENERIC_LOADERS_SOURCE = evas_generic_loaders-$(LIBEVAS_GENERIC_LOADERS_VERSION).tar.bz2
LIBEVAS_GENERIC_LOADERS_SITE = http://download.enlightenment.org/releases
LIBEVAS_GENERIC_LOADERS_LICENSE = GPLv2
LIBEVAS_GENERIC_LOADERS_LICENSE_FILES = COPYING

LIBEVAS_GENERIC_LOADERS_INSTALL_STAGING = YES

LIBEVAS_GENERIC_LOADERS_DEPENDENCIES = libeina zlib

# For now, we only support the SVG loader
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += \
	--disable-poppler \
	--disable-spectre \
	--disable-libraw \
	--disable-gstreamer

ifeq ($(BR2_PACKAGE_LIBEVAS_GENERIC_LOADERS_SVG),y)
LIBEVAS_GENERIC_LOADERS_DEPENDENCIES += librsvg cairo
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += --enable-svg
else
LIBEVAS_GENERIC_LOADERS_CONF_OPTS += --disable-svg
endif

$(eval $(autotools-package))
