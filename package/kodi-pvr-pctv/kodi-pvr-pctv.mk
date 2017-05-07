################################################################################
#
# kodi-pvr-pctv
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_PCTV_VERSION = 85d6eae79876af8a6db2413e3884296520271768
KODI_PVR_PCTV_SITE = $(call github,kodi-pvr,pvr.pctv,$(KODI_PVR_PCTV_VERSION))
KODI_PVR_PCTV_LICENSE = GPL-2.0+
KODI_PVR_PCTV_LICENSE_FILES = src/client.h
KODI_PVR_PCTV_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
