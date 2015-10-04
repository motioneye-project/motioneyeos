################################################################################
#
# kodi-pvr-nextpvr
#
################################################################################

KODI_PVR_NEXTPVR_VERSION = 3a205e49b50baba605d3235f6613fdd36c1d3234
KODI_PVR_NEXTPVR_SITE = $(call github,kodi-pvr,pvr.nextpvr,$(KODI_PVR_NEXTPVR_VERSION))
KODI_PVR_NEXTPVR_LICENSE = GPLv2+
KODI_PVR_NEXTPVR_LICENSE_FILES = src/client.h
KODI_PVR_NEXTPVR_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
