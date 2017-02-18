################################################################################
#
# kodi-screensaver-crystalmorph
#
################################################################################

KODI_SCREENSAVER_CRYSTALMORPH_VERSION = 2e7c10e3543f5aaab6fd2f5aa9d05b976a43ba68
KODI_SCREENSAVER_CRYSTALMORPH_SITE = $(call github,notspiff,screensaver.crystalmorph,$(KODI_SCREENSAVER_CRYSTALMORPH_VERSION))
KODI_SCREENSAVER_CRYSTALMORPH_LICENSE = GPLv2+
KODI_SCREENSAVER_CRYSTALMORPH_LICENSE_FILES = src/Fractal.cpp
KODI_SCREENSAVER_CRYSTALMORPH_DEPENDENCIES = kodi

$(eval $(cmake-package))
