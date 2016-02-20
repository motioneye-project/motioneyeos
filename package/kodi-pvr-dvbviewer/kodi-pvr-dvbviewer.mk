################################################################################
#
# kodi-pvr-dvbviewer
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_DVBVIEWER_VERSION = a6d9b84588a91ca7e4ad5dd65b135753880991fe
KODI_PVR_DVBVIEWER_SITE = $(call github,kodi-pvr,pvr.dvbviewer,$(KODI_PVR_DVBVIEWER_VERSION))
KODI_PVR_DVBVIEWER_LICENSE = GPLv2+
KODI_PVR_DVBVIEWER_LICENSE_FILES = src/client.h
KODI_PVR_DVBVIEWER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
