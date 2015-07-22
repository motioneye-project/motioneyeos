################################################################################
#
# kodi-pvr-njoy
#
################################################################################

KODI_PVR_NJOY_VERSION = 4f88a097cb62b4604ffb0ac293a5dc8f40885e79
KODI_PVR_NJOY_SITE = $(call github,kodi-pvr,pvr.njoy,$(KODI_PVR_NJOY_VERSION))
KODI_PVR_NJOY_LICENSE = GPLv2+
KODI_PVR_NJOY_LICENSE_FILES = src/client.h
KODI_PVR_NJOY_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
