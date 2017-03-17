################################################################################
#
# libraw
#
################################################################################

LIBRAW_VERSION = 0.17.1
LIBRAW_SOURCE = LibRaw-$(LIBRAW_VERSION).tar.gz
LIBRAW_SITE = http://www.libraw.org/data
LIBRAW_PATCH = \
	https://anonscm.debian.org/cgit/pkg-phototools/libraw.git/plain/debian/patches/0001-Fix_gcc6_narrowing_conversion.patch?id=d890937aaca6359df45a66b35e547c94ca564823

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
LIBRAW_CXXFLAGS = $(TARGET_CXXFLAGS)
LIBRAW_CONF_ENV = CXXFLAGS="$(LIBRAW_CXXFLAGS)"

ifeq ($(BR2_PACKAGE_JASPER),y)
LIBRAW_CONF_OPTS += --enable-jasper
LIBRAW_DEPENDENCIES += jasper
# glibc prior to 2.18 only defines constants such as SIZE_MAX or
# INT_FAST32_MAX for C++ code if __STDC_LIMIT_MACROS is defined
LIBRAW_CXXFLAGS += -D__STDC_LIMIT_MACROS
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
