################################################################################
#
# kodi-screensaver-cpblobs
#
################################################################################

KODI_SCREENSAVER_CPBLOBS_VERSION = 87a3abfbe6e4fd1089548eab77a84902d0e1af60
KODI_SCREENSAVER_CPBLOBS_SITE = $(call github,notspiff,screensaver.cpblobs,$(KODI_SCREENSAVER_CPBLOBS_VERSION))
KODI_SCREENSAVER_CPBLOBS_LICENSE = GPLv2
KODI_SCREENSAVER_CPBLOBS_LICENSE_FILES = LICENSE
KODI_SCREENSAVER_CPBLOBS_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
