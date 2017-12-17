################################################################################
#
# kodi-screensaver-asterwave
#
################################################################################

KODI_SCREENSAVER_ASTERWAVE_VERSION = 0dc2c48dadb100954eef823e7e3a5f502ce65b1e
KODI_SCREENSAVER_ASTERWAVE_SITE = $(call github,notspiff,screensaver.asterwave,$(KODI_SCREENSAVER_ASTERWAVE_VERSION))
KODI_SCREENSAVER_ASTERWAVE_DEPENDENCIES = kodi libglu libsoil

$(eval $(cmake-package))
