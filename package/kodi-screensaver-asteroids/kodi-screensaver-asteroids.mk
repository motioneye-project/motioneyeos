################################################################################
#
# kodi-screensaver-asteroids
#
################################################################################

KODI_SCREENSAVER_ASTEROIDS_VERSION = v1.1.2
KODI_SCREENSAVER_ASTEROIDS_SITE = $(call github,notspiff,screensaver.asteroids,$(KODI_SCREENSAVER_ASTEROIDS_VERSION))
KODI_SCREENSAVER_ASTEROIDS_LICENSE = GPL-2.0+
KODI_SCREENSAVER_ASTEROIDS_LICENSE_FILES = src/main.cpp
KODI_SCREENSAVER_ASTEROIDS_DEPENDENCIES = kodi

$(eval $(cmake-package))
