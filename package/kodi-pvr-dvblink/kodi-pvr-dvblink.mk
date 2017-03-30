################################################################################
#
# kodi-pvr-dvblink
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_DVBLINK_VERSION = 06c4e5603e4db0bda3f35e80344a308f486ae0f9
KODI_PVR_DVBLINK_SITE = $(call github,kodi-pvr,pvr.dvblink,$(KODI_PVR_DVBLINK_VERSION))
KODI_PVR_DVBLINK_LICENSE = GPL-2.0+
KODI_PVR_DVBLINK_LICENSE_FILES = src/client.h
KODI_PVR_DVBLINK_DEPENDENCIES = kodi-platform tinyxml2

$(eval $(cmake-package))
