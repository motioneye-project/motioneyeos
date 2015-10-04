################################################################################
#
# kodi-screensaver-greynetic
#
################################################################################

KODI_SCREENSAVER_GREYNETIC_VERSION = 5f370b0f1a51e57719f605344e94824105316c17
KODI_SCREENSAVER_GREYNETIC_SITE = $(call github,notspiff,screensaver.greynetic,$(KODI_SCREENSAVER_GREYNETIC_VERSION))
KODI_SCREENSAVER_GREYNETIC_LICENSE = GPLv2+
KODI_SCREENSAVER_GREYNETIC_LICENSE_FILES = src/GreyNetic.cpp
KODI_SCREENSAVER_GREYNETIC_DEPENDENCIES = kodi

$(eval $(cmake-package))
