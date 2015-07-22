################################################################################
#
# kodi-pvr-dvbviewer
#
################################################################################

KODI_PVR_DVBVIEWER_VERSION = cbfd4552a4381d289bcfb8eda33699ecfd156bd7
KODI_PVR_DVBVIEWER_SITE = $(call github,kodi-pvr,pvr.dvbviewer,$(KODI_PVR_DVBVIEWER_VERSION))
KODI_PVR_DVBVIEWER_LICENSE = GPLv2+
KODI_PVR_DVBVIEWER_LICENSE_FILES = src/client.h
KODI_PVR_DVBVIEWER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
