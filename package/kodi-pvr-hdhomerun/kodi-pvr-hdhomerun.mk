################################################################################
#
# kodi-pvr-hdhomerun
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_HDHOMERUN_VERSION = 8d7b8af10633ad995193fb045cbaac6094a8f98d
KODI_PVR_HDHOMERUN_SITE = $(call github,kodi-pvr,pvr.hdhomerun,$(KODI_PVR_HDHOMERUN_VERSION))
KODI_PVR_HDHOMERUN_LICENSE = GPLv2+
KODI_PVR_HDHOMERUN_LICENSE_FILES = src/client.h
KODI_PVR_HDHOMERUN_DEPENDENCIES = jsoncpp kodi-platform libhdhomerun

$(eval $(cmake-package))
