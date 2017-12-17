################################################################################
#
# kodi-screensaver-greynetic
#
################################################################################

KODI_SCREENSAVER_GREYNETIC_VERSION = 80e850eb3cbc7ee2c937fcab666dc45d2b2ee0bb
KODI_SCREENSAVER_GREYNETIC_SITE = $(call github,notspiff,screensaver.greynetic,$(KODI_SCREENSAVER_GREYNETIC_VERSION))
KODI_SCREENSAVER_GREYNETIC_LICENSE = GPLv2+
KODI_SCREENSAVER_GREYNETIC_LICENSE_FILES = src/GreyNetic.cpp
KODI_SCREENSAVER_GREYNETIC_DEPENDENCIES = kodi

$(eval $(cmake-package))
