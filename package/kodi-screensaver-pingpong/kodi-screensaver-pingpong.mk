################################################################################
#
# kodi-screensaver-pingpong
#
################################################################################

KODI_SCREENSAVER_PINGPONG_VERSION = 2.1.1-Leia
KODI_SCREENSAVER_PINGPONG_SITE = $(call github,xbmc,screensaver.pingpong,$(KODI_SCREENSAVER_PINGPONG_VERSION))
KODI_SCREENSAVER_PINGPONG_LICENSE = GPL-2.0+
KODI_SCREENSAVER_PINGPONG_LICENSE_FILES = src/readme.txt
KODI_SCREENSAVER_PINGPONG_DEPENDENCIES = kodi

$(eval $(cmake-package))
