################################################################################
#
# kodi-screensaver-cpblobs
#
################################################################################

KODI_SCREENSAVER_CPBLOBS_VERSION = 3.0.4-Leia
KODI_SCREENSAVER_CPBLOBS_SITE = $(call github,xbmc,screensaver.cpblobs,$(KODI_SCREENSAVER_CPBLOBS_VERSION))
KODI_SCREENSAVER_CPBLOBS_LICENSE = GPL-2.0
KODI_SCREENSAVER_CPBLOBS_LICENSE_FILES = LICENSE
KODI_SCREENSAVER_CPBLOBS_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
