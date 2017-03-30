################################################################################
#
# kodi-pvr-stalker
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_STALKER_VERSION = 5e588330c453141ae0a2f4fd9c02d909ac9d199e
KODI_PVR_STALKER_SITE = $(call github,kodi-pvr,pvr.stalker,$(KODI_PVR_STALKER_VERSION))
KODI_PVR_STALKER_LICENSE = GPL-2.0+
KODI_PVR_STALKER_LICENSE_FILES = src/client.h
KODI_PVR_STALKER_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
