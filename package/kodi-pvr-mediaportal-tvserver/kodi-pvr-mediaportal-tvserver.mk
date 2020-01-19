################################################################################
#
# kodi-pvr-mediaportal-tvserver
#
################################################################################

KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION = 3.5.18-Leia
KODI_PVR_MEDIAPORTAL_TVSERVER_SITE = $(call github,kodi-pvr,pvr.mediaportal.tvserver,$(KODI_PVR_MEDIAPORTAL_TVSERVER_VERSION))
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE = GPL-2.0+
KODI_PVR_MEDIAPORTAL_TVSERVER_LICENSE_FILES = src/client.h
KODI_PVR_MEDIAPORTAL_TVSERVER_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
