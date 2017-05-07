################################################################################
#
# kodi-pvr-wmc
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_WMC_VERSION = ed67cfedc1dad168c167d86d20fe4d0934504633
KODI_PVR_WMC_SITE = $(call github,kodi-pvr,pvr.wmc,$(KODI_PVR_WMC_VERSION))
KODI_PVR_WMC_LICENSE = GPL-2.0+
KODI_PVR_WMC_LICENSE_FILES = src/client.h
KODI_PVR_WMC_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
