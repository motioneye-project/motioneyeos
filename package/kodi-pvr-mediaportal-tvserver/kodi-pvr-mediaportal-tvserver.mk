################################################################################
#
# kodi-pvr-mediaportal-tvserver
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION = 29e84f8c3a91681cc7bca504c0ba54aa060d5f86
KODI_PVR_MEDIAPORTAL_TVSERVER_SITE = $(call github,kodi-pvr,pvr.mediaportal.tvserver,$(KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION))
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE = GPLv2+
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE_FILES = src/client.h
KODI_PVR_MEDIAPORTAL_TVSERVER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
