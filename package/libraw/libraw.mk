################################################################################
#
# libraw
#
################################################################################

LIBRAW_VERSION = 0.17.1
LIBRAW_SOURCE = LibRaw-$(LIBRAW_VERSION).tar.gz
LIBRAW_SITE = http://www.libraw.org/data
LIBRAW_INSTALL_STAGING = YES
# we patch configure.ac
LIBRAW_AUTORECONF = YES
LIBRAW_CONF_OPTS += \
	--disable-examples \
	--disable-openmp \
	--disable-demosaic-pack-gpl2 \
	--disable-demosaic-pack-gpl3
LIBRAW_LICENSE = LGPLv2.1 or CDDL 1.0 or LibRaw Software License 27032010
LIBRAW_LICENSE_FILES = LICENSE.LGPL LICENSE.CDDL LICENSE.LibRaw.pdf README
LIBRAW_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_JASPER),y)
LIBRAW_CONF_OPTS += --enable-jasper
LIBRAW_DEPENDENCIES += jasper
else
LIBRAW_CONF_OPTS += --disable-jasper
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBRAW_CONF_OPTS += --enable-jpeg
LIBRAW_DEPENDENCIES += jpeg
else
LIBRAW_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_LCMS2),y)
LIBRAW_CONF_OPTS += --enable-lcms
LIBRAW_DEPENDENCIES += lcms2 host-pkgconf
else
LIBRAW_CONF_OPTS += --disable-lcms
endif

$(eval $(autotools-package))
