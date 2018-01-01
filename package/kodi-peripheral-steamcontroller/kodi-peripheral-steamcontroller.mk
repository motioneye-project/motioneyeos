################################################################################
#
# kodi-peripheral-steamcontroller
#
################################################################################

KODI_PERIPHERAL_STEAMCONTROLLER_VERSION = ef527cd81cfcd6c8342691f5c764e5c51df1fca2
KODI_PERIPHERAL_STEAMCONTROLLER_SITE = $(call github,kodi-game,peripheral.steamcontroller,$(KODI_PERIPHERAL_STEAMCONTROLLER_VERSION))
KODI_PERIPHERAL_STEAMCONTROLLER_LICENSE = GPL-2.0+
KODI_PERIPHERAL_STEAMCONTROLLER_LICENSE_FILES = src/addon.cpp
KODI_PERIPHERAL_STEAMCONTROLLER_DEPENDENCIES = kodi-platform libusb

$(eval $(cmake-package))
