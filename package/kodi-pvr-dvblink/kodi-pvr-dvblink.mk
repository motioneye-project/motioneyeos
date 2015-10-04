################################################################################
#
# kodi-pvr-dvblink
#
################################################################################

KODI_PVR_DVBLINK_VERSION = b87e8a79a329c2f808a5d5abffe05259e365d7e6
KODI_PVR_DVBLINK_SITE = $(call github,kodi-pvr,pvr.dvblink,$(KODI_PVR_DVBLINK_VERSION))
KODI_PVR_DVBLINK_LICENSE = GPLv2+
KODI_PVR_DVBLINK_LICENSE_FILES = src/client.h
KODI_PVR_DVBLINK_DEPENDENCIES = kodi-platform tinyxml2

$(eval $(cmake-package))
