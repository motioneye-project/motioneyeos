################################################################################
#
# kodi-screensaver-stars
#
################################################################################

KODI_SCREENSAVER_STARS_VERSION = 1.1.0
KODI_SCREENSAVER_STARS_SITE = $(call github,notspiff,screensaver.stars,v$(KODI_SCREENSAVER_STARS_VERSION))
KODI_SCREENSAVER_STARS_LICENSE = GPL-2.0+
KODI_SCREENSAVER_STARS_LICENSE_FILES = src/StarField.cpp
KODI_SCREENSAVER_STARS_DEPENDENCIES = kodi

$(eval $(cmake-package))
