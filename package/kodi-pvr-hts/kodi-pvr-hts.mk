################################################################################
#
# kodi-pvr-hts
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_HTS_VERSION = 3.4.24-Krypton
KODI_PVR_HTS_SITE = $(call github,kodi-pvr,pvr.hts,$(KODI_PVR_HTS_VERSION))
KODI_PVR_HTS_LICENSE = GPL-2.0+
KODI_PVR_HTS_LICENSE_FILES = src/client.h
KODI_PVR_HTS_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
