################################################################################
#
# kodi-screensaver-matrixtrails
#
################################################################################

KODI_SCREENSAVER_MATRIXTRAILS_VERSION = 16057e7195f930109f0a4aea999296ca315700e5
KODI_SCREENSAVER_MATRIXTRAILS_SITE = $(call github,notspiff,screensaver.matrixtrails,$(KODI_SCREENSAVER_MATRIXTRAILS_VERSION))
KODI_SCREENSAVER_MATRIXTRAILS_LICENSE = GPLv2+
KODI_SCREENSAVER_MATRIXTRAILS_LICENSE_FILES = src/matrixtrails.cpp

KODI_SCREENSAVER_MATRIXTRAILS_DEPENDENCIES = kodi libsoil

$(eval $(cmake-package))
