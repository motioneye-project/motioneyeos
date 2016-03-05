################################################################################
#
# kodi-pvr-mythtv
#
################################################################################

KODI_PVR_MYTHTV_VERSION = 8cb158cebc016f1c2a17014bb21873201ed8957e
KODI_PVR_MYTHTV_SITE = $(call github,kodi-pvr,pvr.mythtv,$(KODI_PVR_MYTHTV_VERSION))
KODI_PVR_MYTHTV_LICENSE = GPLv2+
KODI_PVR_MYTHTV_LICENSE_FILES = src/client.h
KODI_PVR_MYTHTV_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
