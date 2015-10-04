################################################################################
#
# kodi-pvr-mediaportal-tvserver
#
################################################################################

KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION = 29809d10010a21b08b9e652e36bc51dac2171690
KODI_PVR_MEDIAPORTAL_TVSERVER_SITE = $(call github,kodi-pvr,pvr.mediaportal.tvserver,$(KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION))
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE = GPLv2+
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE_FILES = src/client.h
KODI_PVR_MEDIAPORTAL_TVSERVER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
