################################################################################
#
# kodi-pvr-mythtv
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_MYTHTV_VERSION = f278f65fd7593e031ab8fd36f9ace29d8c6f0263
KODI_PVR_MYTHTV_SITE = $(call github,kodi-pvr,pvr.mythtv,$(KODI_PVR_MYTHTV_VERSION))
KODI_PVR_MYTHTV_LICENSE = GPLv2+
KODI_PVR_MYTHTV_LICENSE_FILES = src/client.h
KODI_PVR_MYTHTV_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
