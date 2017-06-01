################################################################################
#
# kodi-pvr-filmon
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_FILMON_VERSION = 1.4.8-Krypton
KODI_PVR_FILMON_SITE = $(call github,kodi-pvr,pvr.filmon,$(KODI_PVR_FILMON_VERSION))
KODI_PVR_FILMON_LICENSE = GPL-2.0+
KODI_PVR_FILMON_LICENSE_FILES = src/client.h
KODI_PVR_FILMON_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
