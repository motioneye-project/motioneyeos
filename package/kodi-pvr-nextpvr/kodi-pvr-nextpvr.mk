################################################################################
#
# kodi-pvr-nextpvr
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_NEXTPVR_VERSION = 288d238a7d59e5957b87fe60775dfaaaed104007
KODI_PVR_NEXTPVR_SITE = $(call github,kodi-pvr,pvr.nextpvr,$(KODI_PVR_NEXTPVR_VERSION))
KODI_PVR_NEXTPVR_LICENSE = GPLv2+
KODI_PVR_NEXTPVR_LICENSE_FILES = src/client.h
KODI_PVR_NEXTPVR_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
