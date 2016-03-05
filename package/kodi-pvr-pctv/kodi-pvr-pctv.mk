################################################################################
#
# kodi-pvr-pctv
#
################################################################################

KODI_PVR_PCTV_VERSION = bca81657a2879a1ab76404e5b5441e2491f35350
KODI_PVR_PCTV_SITE = $(call github,kodi-pvr,pvr.pctv,$(KODI_PVR_PCTV_VERSION))
KODI_PVR_PCTV_LICENSE = GPLv2+
KODI_PVR_PCTV_LICENSE_FILES = src/client.h
KODI_PVR_PCTV_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
