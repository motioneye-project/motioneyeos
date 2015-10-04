################################################################################
#
# kodi-pvr-wmc
#
################################################################################

KODI_PVR_WMC_VERSION = e19c3e99c87e81d406bac0bc4e8edeb47df66dcc
KODI_PVR_WMC_SITE = $(call github,kodi-pvr,pvr.wmc,$(KODI_PVR_WMC_VERSION))
KODI_PVR_WMC_LICENSE = GPLv2+
KODI_PVR_WMC_LICENSE_FILES = src/client.h
KODI_PVR_WMC_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
