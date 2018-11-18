################################################################################
#
# lcms2
#
################################################################################

LCMS2_VERSION = 2.9
LCMS2_SITE = http://downloads.sourceforge.net/project/lcms/lcms/$(LCMS2_VERSION)
LCMS2_LICENSE = MIT
LCMS2_LICENSE_FILES = COPYING
LCMS2_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_JPEG),y)
LCMS2_CONF_OPTS += --with-jpeg
LCMS2_DEPENDENCIES += jpeg
else
LCMS2_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LCMS2_CONF_OPTS += --with-tiff
LCMS2_DEPENDENCIES += tiff
else
LCMS2_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LCMS2_CONF_OPTS += --with-zlib
LCMS2_DEPENDENCIES += zlib
else
LCMS2_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
