################################################################################
#
# kodi-screensaver-stars
#
################################################################################

KODI_SCREENSAVER_STARS_VERSION = 91b59f687ceb52488763aca4ba67d50a92f01731
KODI_SCREENSAVER_STARS_SITE = $(call github,notspiff,screensaver.stars,$(KODI_SCREENSAVER_STARS_VERSION))
KODI_SCREENSAVER_STARS_LICENSE = GPLv2+
KODI_SCREENSAVER_STARS_LICENSE_FILES = src/StarField.cpp
KODI_SCREENSAVER_STARS_DEPENDENCIES = kodi

$(eval $(cmake-package))
