################################################################################
#
# kodi-pvr-wmc
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_WMC_VERSION = 829b5d2ec717a78ac3a5c4f92fbc3379feb80154
KODI_PVR_WMC_SITE = $(call github,kodi-pvr,pvr.wmc,$(KODI_PVR_WMC_VERSION))
KODI_PVR_WMC_LICENSE = GPLv2+
KODI_PVR_WMC_LICENSE_FILES = src/client.h
KODI_PVR_WMC_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
