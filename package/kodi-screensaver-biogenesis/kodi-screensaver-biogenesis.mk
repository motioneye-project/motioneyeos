################################################################################
#
# kodi-screensaver-biogenesis
#
################################################################################

KODI_SCREENSAVER_BIOGENESIS_VERSION = 39928eef56ed639085d401dd97bf18f44b1f3e8b
KODI_SCREENSAVER_BIOGENESIS_SITE = $(call github,notspiff,screensaver.biogenesis,$(KODI_SCREENSAVER_BIOGENESIS_VERSION))
KODI_SCREENSAVER_BIOGENESIS_LICENSE = GPLv2+
KODI_SCREENSAVER_BIOGENESIS_LICENSE_FILES = src/Life.cpp
KODI_SCREENSAVER_BIOGENESIS_DEPENDENCIES = kodi

$(eval $(cmake-package))
