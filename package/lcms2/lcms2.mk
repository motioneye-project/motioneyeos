################################################################################
#
# lcms2
#
################################################################################

LCMS2_VERSION = 2.5
LCMS2_SITE = http://downloads.sourceforge.net/lcms/lcms
LCMS2_LICENSE = MIT
LCMS2_LICENSE_FILES = COPYING

LCMS2_CONF_OPT = \

ifeq ($(BR2_PACKAGE_JPEG),y)
	LCMS2_CONF_OPT += --with-jpeg
	LCMS2_DEPENDENCIES += jpeg
else
	LCMS2_CONF_OPT += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
	LCMS2_CONF_OPT += --with-tiff
	LCMS2_DEPENDENCIES += tiff
else
	LCMS2_CONF_OPT += --without-tiff
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
	LCMS2_CONF_OPT += --with-zlib
	LCMS2_DEPENDENCIES += zlib
else
	LCMS2_CONF_OPT += --without-zlib
endif

$(eval $(autotools-package))
