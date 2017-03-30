################################################################################
#
# kodi-pvr-dvbviewer
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_DVBVIEWER_VERSION = 26286604635a170eeea68df9b7eb52fea0056cfe
KODI_PVR_DVBVIEWER_SITE = $(call github,kodi-pvr,pvr.dvbviewer,$(KODI_PVR_DVBVIEWER_VERSION))
KODI_PVR_DVBVIEWER_LICENSE = GPL-2.0+
KODI_PVR_DVBVIEWER_LICENSE_FILES = src/client.h
KODI_PVR_DVBVIEWER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
