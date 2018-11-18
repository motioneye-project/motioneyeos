################################################################################
#
# kodi-peripheral-joystick
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PERIPHERAL_JOYSTICK_VERSION = v1.3.4
KODI_PERIPHERAL_JOYSTICK_SITE = $(call github,xbmc,peripheral.joystick,$(KODI_PERIPHERAL_JOYSTICK_VERSION))
KODI_PERIPHERAL_JOYSTICK_LICENSE = GPL-2.0+
KODI_PERIPHERAL_JOYSTICK_LICENSE_FILES = src/addon.cpp
KODI_PERIPHERAL_JOYSTICK_DEPENDENCIES = kodi-platform udev

$(eval $(cmake-package))
