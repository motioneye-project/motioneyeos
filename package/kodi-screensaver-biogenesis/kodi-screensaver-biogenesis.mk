################################################################################
#
# kodi-screensaver-biogenesis
#
################################################################################

KODI_SCREENSAVER_BIOGENESIS_VERSION = 2eccbd4e46320de03fde6731c560660659fd34d7
KODI_SCREENSAVER_BIOGENESIS_SITE = $(call github,notspiff,screensaver.biogenesis,$(KODI_SCREENSAVER_BIOGENESIS_VERSION))
KODI_SCREENSAVER_BIOGENESIS_LICENSE = GPLv2+
KODI_SCREENSAVER_BIOGENESIS_LICENSE_FILES = src/Life.cpp
KODI_SCREENSAVER_BIOGENESIS_DEPENDENCIES = kodi

$(eval $(cmake-package))
