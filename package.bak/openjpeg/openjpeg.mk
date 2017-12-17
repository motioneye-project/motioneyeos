################################################################################
#
# openjpeg
#
################################################################################

OPENJPEG_VERSION = 2.1.2
OPENJPEG_SITE = $(call github,uclouvain,openjpeg,v$(OPENJPEG_VERSION))
OPENJPEG_LICENSE = BSD-2c
OPENJPEG_LICENSE_FILES = LICENSE
OPENJPEG_INSTALL_STAGING = YES

OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB),zlib)
OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBPNG),libpng)
OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_TIFF),tiff)
OPENJPEG_DEPENDENCIES += $(if $(BR2_PACKAGE_LCMS2),lcms2)

$(eval $(cmake-package))
