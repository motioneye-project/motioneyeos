################################################################################
#
# kodi-peripheral-xarcade
#
################################################################################

KODI_PERIPHERAL_XARCADE_VERSION = f1875ba4b7aa6ce85ec40fedf48ed5501c79e5fd
KODI_PERIPHERAL_XARCADE_SITE = $(call github,kodi-game,peripheral.xarcade,$(KODI_PERIPHERAL_XARCADE_VERSION))
KODI_PERIPHERAL_XARCADE_LICENSE = GPL-2.0+
KODI_PERIPHERAL_XARCADE_LICENSE_FILES = src/addon.cpp
KODI_PERIPHERAL_XARCADE_DEPENDENCIES = kodi

$(eval $(cmake-package))
