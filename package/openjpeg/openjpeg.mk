################################################################################
#
# openjpeg
#
################################################################################

OPENJPEG_VERSION = 2.3.1
OPENJPEG_SITE = $(call github,uclouvain,openjpeg,v$(OPENJPEG_VERSION))
OPENJPEG_LICENSE = BSD-2-Clause
OPENJPEG_LICENSE_FILES = LICENSE
OPENJPEG_INSTALL_STAGING = YES

# 0004-convertbmp-detect-invalid-file-dimensions-early.patch
# 0005-bmp_read_rle4_data-avoid-potential-infinite-loop.patch
OPENJPEG_IGNORE_CVES += CVE-2019-12973

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
