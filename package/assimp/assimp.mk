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

# workaround SuperH compiler failure when static linking (i.e -fPIC is
# not passed) in gcc versions 5.x or older. The -Os optimization level
# causes a "unable to find a register to spill in class
# ‘GENERAL_REGS’" error. -O2 works fine.
ifeq ($(BR2_sh):$(BR2_STATIC_LIBS):$(BR2_TOOLCHAIN_GCC_AT_LEAST_6),y:y:)
ASSIMP_CXXFLAGS += -O2
endif

ASSIMP_CONF_OPTS += -DASSIMP_BUILD_TESTS=OFF \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(ASSIMP_CXXFLAGS)"

$(eval $(cmake-package))
