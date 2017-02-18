################################################################################
#
# kodi-pvr-nextpvr
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_NEXTPVR_VERSION = 2055105c93e18e04e73c87578bece3edf7525e14
KODI_PVR_NEXTPVR_SITE = $(call github,kodi-pvr,pvr.nextpvr,$(KODI_PVR_NEXTPVR_VERSION))
KODI_PVR_NEXTPVR_LICENSE = GPLv2+
KODI_PVR_NEXTPVR_LICENSE_FILES = src/client.h
KODI_PVR_NEXTPVR_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
