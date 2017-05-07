################################################################################
#
# kodi-pvr-stalker
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_STALKER_VERSION = df111a0d0a67669b732d8986e5473f3ffd9d7d9c
KODI_PVR_STALKER_SITE = $(call github,kodi-pvr,pvr.stalker,$(KODI_PVR_STALKER_VERSION))
KODI_PVR_STALKER_LICENSE = GPL-2.0+
KODI_PVR_STALKER_LICENSE_FILES = src/client.h
KODI_PVR_STALKER_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
