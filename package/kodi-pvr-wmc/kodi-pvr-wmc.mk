################################################################################
#
# kodi-pvr-wmc
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_WMC_VERSION = 949fcd162206b569af15942180e6c133ad61e336
KODI_PVR_WMC_SITE = $(call github,kodi-pvr,pvr.wmc,$(KODI_PVR_WMC_VERSION))
KODI_PVR_WMC_LICENSE = GPLv2+
KODI_PVR_WMC_LICENSE_FILES = src/client.h
KODI_PVR_WMC_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
