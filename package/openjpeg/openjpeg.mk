################################################################################
#
# openjpeg
#
################################################################################

OPENJPEG_VERSION = 51f097e6d5754ddae93e716276fe8176b44ec548
OPENJPEG_SITE = $(call github,uclouvain,openjpeg,$(OPENJPEG_VERSION))
OPENJPEG_LICENSE = BSD-2-Clause
OPENJPEG_LICENSE_FILES = LICENSE
OPENJPEG_INSTALL_STAGING = YES

OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB),zlib)
OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBPNG),libpng)
OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_TIFF),tiff)
OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_LCMS2),lcms2)

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
OPENJPEG_CONF_OPTS += -DOPJ_USE_THREAD=ON
else
OPENJPEG_CONF_OPTS += -DOPJ_USE_THREAD=OFF
endif

$(eval $(cmake-package))
