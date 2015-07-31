################################################################################
#
# kodi-pvr-hts
#
################################################################################

KODI_PVR_HTS_VERSION = 9b05d4cbdda80d12cc8d90b6cc2c80ab6f65e4d2
KODI_PVR_HTS_SITE = $(call github,kodi-pvr,pvr.hts,$(KODI_PVR_HTS_VERSION))
KODI_PVR_HTS_LICENSE = GPLv2+
KODI_PVR_HTS_LICENSE_FILES = src/client.h
KODI_PVR_HTS_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
