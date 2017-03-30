################################################################################
#
# kodi-screensaver-pingpong
#
################################################################################

KODI_SCREENSAVER_PINGPONG_VERSION = 5c7cf6fd9f9ff1468f620bb891e66bebd3a5fe17
KODI_SCREENSAVER_PINGPONG_SITE = $(call github,notspiff,screensaver.pingpong,$(KODI_SCREENSAVER_PINGPONG_VERSION))
KODI_SCREENSAVER_PINGPONG_LICENSE = GPL-2.0+
KODI_SCREENSAVER_PINGPONG_LICENSE_FILES = src/readme.txt
KODI_SCREENSAVER_PINGPONG_DEPENDENCIES = kodi

$(eval $(cmake-package))
