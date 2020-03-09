################################################################################
#
# kodi-pvr-stalker
#
################################################################################

KODI_PVR_STALKER_VERSION = 3.4.10-Leia
KODI_PVR_STALKER_SITE = $(call github,kodi-pvr,pvr.stalker,$(KODI_PVR_STALKER_VERSION))
KODI_PVR_STALKER_LICENSE = GPL-2.0+
KODI_PVR_STALKER_LICENSE_FILES = debian/copyright
KODI_PVR_STALKER_DEPENDENCIES = jsoncpp kodi-platform libxml2

$(eval $(cmake-package))
