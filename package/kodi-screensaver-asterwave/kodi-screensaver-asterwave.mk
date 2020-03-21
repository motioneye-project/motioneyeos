################################################################################
#
# kodi-screensaver-asterwave
#
################################################################################

KODI_SCREENSAVER_ASTERWAVE_VERSION = 3.0.4-Leia
KODI_SCREENSAVER_ASTERWAVE_SITE = $(call github,xbmc,screensaver.asterwave,$(KODI_SCREENSAVER_ASTERWAVE_VERSION))
KODI_SCREENSAVER_ASTERWAVE_LICENSE = GPL-2.0+
KODI_SCREENSAVER_ASTERWAVE_LICENSE_FILES = debian/copyright
KODI_SCREENSAVER_ASTERWAVE_DEPENDENCIES = kodi libglu libsoil

$(eval $(cmake-package))
