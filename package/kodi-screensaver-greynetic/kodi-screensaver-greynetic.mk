################################################################################
#
# kodi-screensaver-greynetic
#
################################################################################

KODI_SCREENSAVER_GREYNETIC_VERSION = 2.2.2-Leia
KODI_SCREENSAVER_GREYNETIC_SITE = $(call github,xbmc,screensaver.greynetic,$(KODI_SCREENSAVER_GREYNETIC_VERSION))
KODI_SCREENSAVER_GREYNETIC_LICENSE = GPL-2.0+
KODI_SCREENSAVER_GREYNETIC_LICENSE_FILES = debian/copyright
KODI_SCREENSAVER_GREYNETIC_DEPENDENCIES = kodi

$(eval $(cmake-package))
