################################################################################
#
# libraw
#
################################################################################

LIBRAW_VERSION = 0.13.4
LIBRAW_SOURCE = LibRaw-$(LIBRAW_VERSION).tar.gz
LIBRAW_SITE = http://www.libraw.org/data
LIBRAW_INSTALL_STAGING = YES
LIBRAW_CONF_OPTS += \
	--disable-examples \
	--disable-lcms \
	--disable-openmp \
	--disable-demosaic-pack-gpl2 \
	--disable-demosaic-pack-gpl3
LIBRAW_LICENSE = LGPLv2.1 or CDDL 1.0 or LibRaw Software License 27032010
LIBRAW_LICENSE_FILES = LICENSE.LGPL LICENSE.CDDL LICENSE.LibRaw.pdf README

$(eval $(autotools-package))
