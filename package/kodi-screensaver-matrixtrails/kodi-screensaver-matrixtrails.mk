################################################################################
#
# kodi-screensaver-matrixtrails
#
################################################################################

KODI_SCREENSAVER_MATRIXTRAILS_VERSION = 2.2.1-Leia
KODI_SCREENSAVER_MATRIXTRAILS_SITE = $(call github,xbmc,screensaver.matrixtrails,v$(KODI_SCREENSAVER_MATRIXTRAILS_VERSION))
KODI_SCREENSAVER_MATRIXTRAILS_LICENSE = GPL-2.0+
KODI_SCREENSAVER_MATRIXTRAILS_LICENSE_FILES = src/matrixtrails.cpp
KODI_SCREENSAVER_MATRIXTRAILS_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
