################################################################################
#
# kodi-screensaver-stars
#
################################################################################

KODI_SCREENSAVER_STARS_VERSION = 28bf79d4dce040e9fbdc25f51007e13950cab937
KODI_SCREENSAVER_STARS_SITE = $(call github,notspiff,screensaver.stars,$(KODI_SCREENSAVER_STARS_VERSION))
KODI_SCREENSAVER_STARS_LICENSE = GPLv2+
KODI_SCREENSAVER_STARS_LICENSE_FILES = src/StarField.cpp
KODI_SCREENSAVER_STARS_DEPENDENCIES = kodi

$(eval $(cmake-package))
