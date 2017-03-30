################################################################################
#
# kodi-pvr-vdr-vnsi
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_VDR_VNSI_VERSION = 7e11b853637ec436e30e4ac826de6ee87c303482
KODI_PVR_VDR_VNSI_SITE = $(call github,kodi-pvr,pvr.vdr.vnsi,$(KODI_PVR_VDR_VNSI_VERSION))
KODI_PVR_VDR_VNSI_LICENSE = GPL-2.0+
KODI_PVR_VDR_VNSI_LICENSE_FILES = src/client.h
KODI_PVR_VDR_VNSI_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
