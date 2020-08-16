################################################################################
#
# kodi-peripheral-steamcontroller
#
################################################################################

KODI_PERIPHERAL_STEAMCONTROLLER_VERSION = 702fea828f9c5c94d0bd77dbb5fe78451edfa2ea
KODI_PERIPHERAL_STEAMCONTROLLER_SITE = $(call github,kodi-game,peripheral.steamcontroller,$(KODI_PERIPHERAL_STEAMCONTROLLER_VERSION))
KODI_PERIPHERAL_STEAMCONTROLLER_LICENSE = GPL-2.0+
KODI_PERIPHERAL_STEAMCONTROLLER_LICENSE_FILES = debian/copyright
KODI_PERIPHERAL_STEAMCONTROLLER_DEPENDENCIES = kodi-platform libusb

$(eval $(cmake-package))
