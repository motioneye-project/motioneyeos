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

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k),y)
ASSIMP_CXXFLAGS += -mxgot
endif

ASSIMP_CONF_OPTS += -DASSIMP_BUILD_TESTS=OFF -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(ASSIMP_CXXFLAGS)"

$(eval $(cmake-package))
