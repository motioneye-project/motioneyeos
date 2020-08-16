################################################################################
#
# kodi-screensaver-crystalmorph
#
################################################################################

KODI_SCREENSAVER_CRYSTALMORPH_VERSION = 4439c84c38abf889e19a1863e745942c0d7f8203
KODI_SCREENSAVER_CRYSTALMORPH_SITE = $(call github,notspiff,screensaver.crystalmorph,$(KODI_SCREENSAVER_CRYSTALMORPH_VERSION))
KODI_SCREENSAVER_CRYSTALMORPH_LICENSE = GPL-2.0+
KODI_SCREENSAVER_CRYSTALMORPH_LICENSE_FILES = src/Fractal.cpp
KODI_SCREENSAVER_CRYSTALMORPH_DEPENDENCIES = kodi

$(eval $(cmake-package))
