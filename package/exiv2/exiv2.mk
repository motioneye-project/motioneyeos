################################################################################
#
# exiv2
#
################################################################################

EXIV2_VERSION = 0.24
EXIV2_SITE = http://www.exiv2.org
EXIV2_INSTALL_STAGING = YES

EXIV2_CONF_OPTS += -DEXIV2_ENABLE_BUILD_SAMPLES=OFF

ifeq ($(BR2_PACKAGE_EXIV2_LENSDATA),)
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_LENSDATA=OFF
endif

ifeq ($(BR2_PACKAGE_EXIV2_COMMERCIAL),y)
EXIV2_LICENSE = commercial
# NLS support is disabled in commercial version due to the copyright
# of the translated texts.
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_COMMERCIAL=ON -DEXIV2_ENABLE_NLS=OFF
else
EXIV2_LICENSE = GPLv2+
EXIV2_LICENSE_FILES = COPYING
endif

ifeq ($(BR2_PACKAGE_EXIV2_PNG),y)
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_PNG=ON
EXIV2_DEPENDENCIES += zlib
else
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_PNG=OFF
endif

ifeq ($(BR2_PACKAGE_EXIV2_XMP),y)
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_XMP=ON -DEXIV2_ENABLE_LIBXMP=ON
EXIV2_DEPENDENCIES += expat
else
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_XMP=OFF -DEXIV2_ENABLE_LIBXMP=OFF
endif

ifeq ($(BR2_ENABLE_LOCALE),y)
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_NLS=ON
else
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_NLS=OFF
endif

$(eval $(cmake-package))
