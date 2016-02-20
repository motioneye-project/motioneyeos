################################################################################
#
# kodi-pvr-stalker
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_STALKER_VERSION = e31351527b712c85b669eb876eb12f5809e400d7
KODI_PVR_STALKER_SITE = $(call github,kodi-pvr,pvr.stalker,$(KODI_PVR_STALKER_VERSION))
KODI_PVR_STALKER_LICENSE = GPLv2+
KODI_PVR_STALKER_LICENSE_FILES = src/client.h
KODI_PVR_STALKER_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
