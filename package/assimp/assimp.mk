################################################################################
#
# assimp
#
################################################################################

ASSIMP_VERSION = v3.2
ASSIMP_SITE = $(call github,assimp,assimp,$(ASSIMP_VERSION))
ASSIMP_LICENSE = BSD-3c
ASSIMP_LICENSE_FILES = LICENSE
ASSIMP_DEPENDENCIES = zlib
ASSIMP_INSTALL_STAGING = YES

ASSIMP_CONF_OPTS += -DASSIMP_BUILD_TESTS=OFF

$(eval $(cmake-package))
