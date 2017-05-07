################################################################################
#
# kodi-pvr-hdhomerun
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_HDHOMERUN_VERSION = 60d89d16dd953d38947e8a6da2f8bb84a0f764ef
KODI_PVR_HDHOMERUN_SITE = $(call github,kodi-pvr,pvr.hdhomerun,$(KODI_PVR_HDHOMERUN_VERSION))
KODI_PVR_HDHOMERUN_LICENSE = GPL-2.0+
KODI_PVR_HDHOMERUN_LICENSE_FILES = src/client.h
KODI_PVR_HDHOMERUN_DEPENDENCIES = jsoncpp kodi-platform libhdhomerun

$(eval $(cmake-package))
