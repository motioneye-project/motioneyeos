################################################################################
#
# kodi-screensaver-biogenesis
#
################################################################################

KODI_SCREENSAVER_BIOGENESIS_VERSION = v1.1.0
KODI_SCREENSAVER_BIOGENESIS_SITE = $(call github,notspiff,screensaver.biogenesis,$(KODI_SCREENSAVER_BIOGENESIS_VERSION))
KODI_SCREENSAVER_BIOGENESIS_LICENSE = GPL-2.0+
KODI_SCREENSAVER_BIOGENESIS_LICENSE_FILES = src/Life.cpp
KODI_SCREENSAVER_BIOGENESIS_DEPENDENCIES = kodi

$(eval $(cmake-package))
