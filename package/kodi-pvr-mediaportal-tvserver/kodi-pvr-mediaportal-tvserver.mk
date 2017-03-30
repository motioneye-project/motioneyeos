################################################################################
#
# kodi-pvr-mediaportal-tvserver
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION = a3dd464379a56131bae61b94275c14a3abcf2869
KODI_PVR_MEDIAPORTAL_TVSERVER_SITE = $(call github,kodi-pvr,pvr.mediaportal.tvserver,$(KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION))
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE = GPL-2.0+
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE_FILES = src/client.h
KODI_PVR_MEDIAPORTAL_TVSERVER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
