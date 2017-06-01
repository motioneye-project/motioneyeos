################################################################################
#
# kodi-pvr-wmc
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_WMC_VERSION = 1.4.9v2-Krypton
KODI_PVR_WMC_SITE = $(call github,kodi-pvr,pvr.wmc,$(KODI_PVR_WMC_VERSION))
KODI_PVR_WMC_LICENSE = GPL-2.0+
KODI_PVR_WMC_LICENSE_FILES = src/client.h
KODI_PVR_WMC_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
