################################################################################
#
# exiv2
#
################################################################################

EXIV2_VERSION = 910f3507795e1930ae216c9febee0bf9a88e99c0
EXIV2_SITE = $(call github,Exiv2,exiv2,$(EXIV2_VERSION))
EXIV2_INSTALL_STAGING = YES

EXIV2_CONF_OPTS += -DEXIV2_ENABLE_BUILD_SAMPLES=OFF

# The following CMake variable disables a TRY_RUN call in the -pthread
# test which is not allowed when cross-compiling.
EXIV2_CONF_OPTS += -DTHREADS_PTHREAD_ARG=OFF

ifeq ($(BR2_PACKAGE_EXIV2_LENSDATA),)
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_LENSDATA=OFF
endif

ifeq ($(BR2_PACKAGE_EXIV2_COMMERCIAL),y)
EXIV2_LICENSE = commercial
# NLS support is disabled in commercial version due to the copyright
# of the translated texts.
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_COMMERCIAL=ON -DEXIV2_ENABLE_NLS=OFF
else
EXIV2_LICENSE = GPL-2.0+
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
ifeq ($(BR2_PACKAGE_GETTEXT),y)
EXIV2_DEPENDENCIES += gettext
endif
else
EXIV2_CONF_OPTS += -DEXIV2_ENABLE_NLS=OFF
endif

$(eval $(cmake-package))
