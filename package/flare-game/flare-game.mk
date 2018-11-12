################################################################################
#
# flare-game
#
################################################################################

FLARE_GAME_VERSION = v1.0
FLARE_GAME_SITE =  $(call github,clintbellanger,flare-game,$(FLARE_GAME_VERSION))
FLARE_GAME_LICENSE = CC-BY-SA-3.0 (data files), GPL-2.0 (GNU Unifont), \
	OFL-1.1 (Liberation Sans)
FLARE_GAME_LICENSE_FILES = README

FLARE_GAME_DEPENDENCIES = flare-engine

# Don't use /usr/share/games
FLARE_GAME_CONF_OPTS += -DDATADIR=share/flare

$(eval $(cmake-package))
