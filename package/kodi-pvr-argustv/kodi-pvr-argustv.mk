################################################################################
#
# kodi-pvr-argustv
#
################################################################################

KODI_PVR_ARGUSTV_VERSION = 32f03271cc3fb1b50edfacd2793d5ac70a98dd20
KODI_PVR_ARGUSTV_SITE = $(call github,kodi-pvr,pvr.argustv,$(KODI_PVR_ARGUSTV_VERSION))
KODI_PVR_ARGUSTV_LICENSE = GPLv2+
KODI_PVR_ARGUSTV_LICENSE_FILES = src/client.h
KODI_PVR_ARGUSTV_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
