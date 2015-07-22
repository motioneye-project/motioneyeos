################################################################################
#
# kodi-pvr-mythtv
#
################################################################################

KODI_PVR_MYTHTV_VERSION = 75fee97e2e690b0ee6d2b1540218b61586683e20
KODI_PVR_MYTHTV_SITE = $(call github,kodi-pvr,pvr.mythtv,$(KODI_PVR_MYTHTV_VERSION))
KODI_PVR_MYTHTV_LICENSE = GPLv2+
KODI_PVR_MYTHTV_LICENSE_FILES = src/client.h
KODI_PVR_MYTHTV_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
