################################################################################
#
# kodi-pvr-hts
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_HTS_VERSION = 4e2a8334d4e62e63720a33a18c3e3c7ff4b4ad0b
KODI_PVR_HTS_SITE = $(call github,kodi-pvr,pvr.hts,$(KODI_PVR_HTS_VERSION))
KODI_PVR_HTS_LICENSE = GPL-2.0+
KODI_PVR_HTS_LICENSE_FILES = src/client.h
KODI_PVR_HTS_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
