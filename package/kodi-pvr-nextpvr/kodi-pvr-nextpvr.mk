################################################################################
#
# kodi-pvr-nextpvr
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_NEXTPVR_VERSION = 2.4.13-Krypton
KODI_PVR_NEXTPVR_SITE = $(call github,kodi-pvr,pvr.nextpvr,$(KODI_PVR_NEXTPVR_VERSION))
KODI_PVR_NEXTPVR_LICENSE = GPL-2.0+
KODI_PVR_NEXTPVR_LICENSE_FILES = src/client.h
KODI_PVR_NEXTPVR_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
