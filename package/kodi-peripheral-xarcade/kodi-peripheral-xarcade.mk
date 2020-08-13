################################################################################
#
# kodi-peripheral-xarcade
#
################################################################################

KODI_PERIPHERAL_XARCADE_VERSION = 51e1a4550a6c7d7feeb01760a731af17bea6c524
KODI_PERIPHERAL_XARCADE_SITE = $(call github,kodi-game,peripheral.xarcade,$(KODI_PERIPHERAL_XARCADE_VERSION))
KODI_PERIPHERAL_XARCADE_LICENSE = GPL-2.0+
KODI_PERIPHERAL_XARCADE_LICENSE_FILES = debian/copyright
KODI_PERIPHERAL_XARCADE_DEPENDENCIES = kodi

$(eval $(cmake-package))
