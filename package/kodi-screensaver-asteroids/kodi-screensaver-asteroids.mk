################################################################################
#
# kodi-screensaver-asteroids
#
################################################################################

KODI_SCREENSAVER_ASTEROIDS_VERSION = 2.3.1-Leia
KODI_SCREENSAVER_ASTEROIDS_SITE = $(call github,xbmc,screensaver.asteroids,$(KODI_SCREENSAVER_ASTEROIDS_VERSION))
KODI_SCREENSAVER_ASTEROIDS_LICENSE = GPL-2.0+
KODI_SCREENSAVER_ASTEROIDS_LICENSE_FILES = src/main.cpp
KODI_SCREENSAVER_ASTEROIDS_DEPENDENCIES = glm kodi

$(eval $(cmake-package))
