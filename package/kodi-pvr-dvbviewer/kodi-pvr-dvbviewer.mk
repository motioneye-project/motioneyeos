################################################################################
#
# kodi-pvr-dvbviewer
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_DVBVIEWER_VERSION = 602042c9a7aa0035d799c6296e6ea06b5d5c3c4f
KODI_PVR_DVBVIEWER_SITE = $(call github,kodi-pvr,pvr.dvbviewer,$(KODI_PVR_DVBVIEWER_VERSION))
KODI_PVR_DVBVIEWER_LICENSE = GPL-2.0+
KODI_PVR_DVBVIEWER_LICENSE_FILES = src/client.h
KODI_PVR_DVBVIEWER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
