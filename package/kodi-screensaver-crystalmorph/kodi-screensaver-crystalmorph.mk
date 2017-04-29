################################################################################
#
# kodi-screensaver-crystalmorph
#
################################################################################

KODI_SCREENSAVER_CRYSTALMORPH_VERSION = 1dc9bf3f57cc2c5345efec64d9499c3bf8f7bd6e
KODI_SCREENSAVER_CRYSTALMORPH_SITE = $(call github,notspiff,screensaver.crystalmorph,$(KODI_SCREENSAVER_CRYSTALMORPH_VERSION))
KODI_SCREENSAVER_CRYSTALMORPH_LICENSE = GPL-2.0+
KODI_SCREENSAVER_CRYSTALMORPH_LICENSE_FILES = src/Fractal.cpp
KODI_SCREENSAVER_CRYSTALMORPH_DEPENDENCIES = kodi

$(eval $(cmake-package))
