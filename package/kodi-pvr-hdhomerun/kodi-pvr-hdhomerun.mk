################################################################################
#
# kodi-pvr-hdhomerun
#
################################################################################

KODI_PVR_HDHOMERUN_VERSION = 3.5.0-Leia
KODI_PVR_HDHOMERUN_SITE = $(call github,kodi-pvr,pvr.hdhomerun,$(KODI_PVR_HDHOMERUN_VERSION))
KODI_PVR_HDHOMERUN_LICENSE = GPL-2.0+
KODI_PVR_HDHOMERUN_LICENSE_FILES = src/client.h
KODI_PVR_HDHOMERUN_DEPENDENCIES = jsoncpp kodi-platform libhdhomerun

$(eval $(cmake-package))
