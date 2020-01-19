################################################################################
#
# kodi-pvr-vbox
#
################################################################################

KODI_PVR_VBOX_VERSION = 4.7.0-Leia
KODI_PVR_VBOX_SITE = $(call github,kodi-pvr,pvr.vbox,$(KODI_PVR_VBOX_VERSION))
KODI_PVR_VBOX_LICENSE = GPL-2.0+
KODI_PVR_VBOX_LICENSE_FILES = src/client.h
KODI_PVR_VBOX_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
