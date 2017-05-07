################################################################################
#
# kodi-pvr-vdr-vnsi
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_VDR_VNSI_VERSION = 4ed7d602924dbfcdd2770c0e13423092e829460d
KODI_PVR_VDR_VNSI_SITE = $(call github,kodi-pvr,pvr.vdr.vnsi,$(KODI_PVR_VDR_VNSI_VERSION))
KODI_PVR_VDR_VNSI_LICENSE = GPL-2.0+
KODI_PVR_VDR_VNSI_LICENSE_FILES = src/client.h
KODI_PVR_VDR_VNSI_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
