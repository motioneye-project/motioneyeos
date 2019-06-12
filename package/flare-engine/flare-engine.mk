################################################################################
#
# flare-engine
#
################################################################################

FLARE_ENGINE_VERSION = 1.0
FLARE_ENGINE_SITE =  $(call github,clintbellanger,flare-engine,v$(FLARE_ENGINE_VERSION))
FLARE_ENGINE_LICENSE = GPL-3.0+
FLARE_ENGINE_LICENSE_FILES = COPYING

FLARE_ENGINE_DEPENDENCIES += sdl2 sdl2_image sdl2_mixer sdl2_ttf

# Don't use /usr/games and /usr/share/games
FLARE_ENGINE_CONF_OPTS += -DBINDIR=bin -DDATADIR=share/flare

# Don't use the default Debug type as it adds -pg (gprof)
ifeq ($(BR2_ENABLE_DEBUG),y)
FLARE_ENGINE_CONF_OPTS += -DCMAKE_BUILD_TYPE=RelWithDebInfo
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
# CMakeLists.txt sets CMAKE_CXX_FLAGS_<BUILD_TYPE> depending on
# BUILD_TYPE, and this comes after the generic CMAKE_CXX_FLAGS.
# Override CMAKE_BUILD_TYPE so no overrides are applied.
FLARE_ENGINE_CONF_OPTS += -DCMAKE_BUILD_TYPE=Buildroot
FLARE_ENGINE_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -O0"
endif

$(eval $(cmake-package))
