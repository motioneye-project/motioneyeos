################################################################################
#
# physfs
#
################################################################################

PHYSFS_VERSION = be27dfd07d97336145e7f49d3fd200a6e902f85e
PHYSFS_SITE = https://hg.icculus.org/icculus/physfs
PHYSFS_SITE_METHOD = hg

PHYSFS_LICENSE = Zlib (physfs), LGPL with exceptions (lzma)
PHYSFS_LICENSE_FILES = LICENSE.txt src/lzma/LGPL.txt

PHYSFS_INSTALL_STAGING = YES

PHYSFS_CONF_OPTS = -DPHYSFS_BUILD_TEST=OFF

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
PHYSFS_CONF_OPTS += -DPHYSFS_BUILD_SHARED=ON
else
PHYSFS_CONF_OPTS += -DPHYSFS_BUILD_SHARED=OFF
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
PHYSFS_CONF_OPTS += -DPHYSFS_BUILD_STATIC=ON
else
PHYSFS_CONF_OPTS += -DPHYSFS_BUILD_STATIC=OFF
endif

$(eval $(cmake-package))
