################################################################################
#
# flare-engine
#
################################################################################

FLARE_ENGINE_VERSION = v1.0
FLARE_ENGINE_SITE =  $(call github,clintbellanger,flare-engine,$(FLARE_ENGINE_VERSION))
FLARE_ENGINE_LICENSE = GPL-3.0+
FLARE_ENGINE_LICENSE_FILES = COPYING

FLARE_ENGINE_DEPENDENCIES += sdl2 sdl2_image sdl2_mixer sdl2_ttf

# Don't use /usr/games and /usr/share/games
FLARE_ENGINE_CONF_OPTS += -DBINDIR=bin -DDATADIR=share/flare

# Don't use the default Debug type as it adds -pg (gprof)
ifeq ($(BR2_ENABLE_DEBUG),y)
FLARE_ENGINE_CONF_OPTS += -DCMAKE_BUILD_TYPE=RelWithDebInfo
endif

$(eval $(cmake-package))
