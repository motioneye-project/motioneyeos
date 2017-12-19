################################################################################
#
# kodi-screensaver-greynetic
#
################################################################################

KODI_SCREENSAVER_GREYNETIC_VERSION = v1.1.0
KODI_SCREENSAVER_GREYNETIC_SITE = $(call github,notspiff,screensaver.greynetic,$(KODI_SCREENSAVER_GREYNETIC_VERSION))
KODI_SCREENSAVER_GREYNETIC_LICENSE = GPL-2.0+
KODI_SCREENSAVER_GREYNETIC_LICENSE_FILES = src/GreyNetic.cpp
KODI_SCREENSAVER_GREYNETIC_DEPENDENCIES = kodi

$(eval $(cmake-package))
