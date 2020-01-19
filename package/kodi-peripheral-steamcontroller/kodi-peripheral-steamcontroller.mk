################################################################################
#
# kodi-peripheral-steamcontroller
#
################################################################################

KODI_PERIPHERAL_STEAMCONTROLLER_VERSION = 0347e66dc8464184d636aea2cfe10491d6fcda96
KODI_PERIPHERAL_STEAMCONTROLLER_SITE = $(call github,kodi-game,peripheral.steamcontroller,$(KODI_PERIPHERAL_STEAMCONTROLLER_VERSION))
KODI_PERIPHERAL_STEAMCONTROLLER_LICENSE = GPL-2.0+
KODI_PERIPHERAL_STEAMCONTROLLER_LICENSE_FILES = src/addon.cpp
KODI_PERIPHERAL_STEAMCONTROLLER_DEPENDENCIES = kodi-platform libusb

$(eval $(cmake-package))
