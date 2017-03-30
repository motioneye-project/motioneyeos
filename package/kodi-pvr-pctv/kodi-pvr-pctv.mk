################################################################################
#
# kodi-pvr-pctv
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_PCTV_VERSION = 0096770e96f84c46f444e159b9b737ac8b4238dc
KODI_PVR_PCTV_SITE = $(call github,kodi-pvr,pvr.pctv,$(KODI_PVR_PCTV_VERSION))
KODI_PVR_PCTV_LICENSE = GPL-2.0+
KODI_PVR_PCTV_LICENSE_FILES = src/client.h
KODI_PVR_PCTV_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
