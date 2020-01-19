################################################################################
#
# kodi-screensaver-stars
#
################################################################################

KODI_SCREENSAVER_STARS_VERSION = 2.1.3-Leia
KODI_SCREENSAVER_STARS_SITE = $(call github,xbmc,screensaver.stars,$(KODI_SCREENSAVER_STARS_VERSION))
KODI_SCREENSAVER_STARS_LICENSE = GPL-2.0+
KODI_SCREENSAVER_STARS_LICENSE_FILES = src/StarField.cpp
KODI_SCREENSAVER_STARS_DEPENDENCIES = kodi

$(eval $(cmake-package))
