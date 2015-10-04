################################################################################
#
# kodi-screensaver-asteroids
#
################################################################################

KODI_SCREENSAVER_ASTEROIDS_VERSION = d4c2e3b499544ef55be364b34e5569d9c31c9615
KODI_SCREENSAVER_ASTEROIDS_SITE = $(call github,notspiff,screensaver.asteroids,$(KODI_SCREENSAVER_ASTEROIDS_VERSION))
KODI_SCREENSAVER_ASTEROIDS_LICENSE = GPLv2+
KODI_SCREENSAVER_ASTEROIDS_LICENSE_FILES = src/main.cpp
KODI_SCREENSAVER_ASTEROIDS_DEPENDENCIES = kodi

$(eval $(cmake-package))
