################################################################################
#
# kodi-pvr-filmon
#
################################################################################

KODI_PVR_FILMON_VERSION = 5c41f4e361c9bcdd6e53cffd541222c5aa131a27
KODI_PVR_FILMON_SITE = $(call github,kodi-pvr,pvr.filmon,$(KODI_PVR_FILMON_VERSION))
KODI_PVR_FILMON_LICENSE = GPLv2+
KODI_PVR_FILMON_LICENSE_FILES = src/client.h
KODI_PVR_FILMON_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
