################################################################################
#
# kodi-pvr-filmon
#
################################################################################

KODI_PVR_FILMON_VERSION = 67abb5696798aa954b38de2cc7b4a74e6554d627
KODI_PVR_FILMON_SITE = $(call github,kodi-pvr,pvr.filmon,$(KODI_PVR_FILMON_VERSION))
KODI_PVR_FILMON_LICENSE = GPLv2+
KODI_PVR_FILMON_LICENSE_FILES = src/client.h
KODI_PVR_FILMON_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
