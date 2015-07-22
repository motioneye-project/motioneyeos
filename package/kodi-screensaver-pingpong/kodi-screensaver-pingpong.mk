################################################################################
#
# kodi-screensaver-pingpong
#
################################################################################

KODI_SCREENSAVER_PINGPONG_VERSION = 00fd2a7c70d581ada1bc89829c6870530b4c65b9
KODI_SCREENSAVER_PINGPONG_SITE = $(call github,notspiff,screensaver.pingpong,$(KODI_SCREENSAVER_PINGPONG_VERSION))
KODI_SCREENSAVER_PINGPONG_LICENSE = GPLv2+
KODI_SCREENSAVER_PINGPONG_LICENSE_FILES = src/readme.txt
KODI_SCREENSAVER_PINGPONG_DEPENDENCIES = kodi

$(eval $(cmake-package))
