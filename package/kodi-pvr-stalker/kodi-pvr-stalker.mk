################################################################################
#
# kodi-pvr-stalker
#
################################################################################

KODI_PVR_STALKER_VERSION = a89afb8a2f5e01e3d11f6887ba1f7c81aebd7515
KODI_PVR_STALKER_SITE = $(call github,kodi-pvr,pvr.stalker,$(KODI_PVR_STALKER_VERSION))
KODI_PVR_STALKER_LICENSE = GPLv2+
KODI_PVR_STALKER_LICENSE_FILES = src/client.h
KODI_PVR_STALKER_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
