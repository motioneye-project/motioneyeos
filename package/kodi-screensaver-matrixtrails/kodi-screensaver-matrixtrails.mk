################################################################################
#
# kodi-screensaver-matrixtrails
#
################################################################################

KODI_SCREENSAVER_MATRIXTRAILS_VERSION = v1.1.0
KODI_SCREENSAVER_MATRIXTRAILS_SITE = $(call github,notspiff,screensaver.matrixtrails,$(KODI_SCREENSAVER_MATRIXTRAILS_VERSION))
KODI_SCREENSAVER_MATRIXTRAILS_LICENSE = GPL-2.0+
KODI_SCREENSAVER_MATRIXTRAILS_LICENSE_FILES = src/matrixtrails.cpp

KODI_SCREENSAVER_MATRIXTRAILS_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
