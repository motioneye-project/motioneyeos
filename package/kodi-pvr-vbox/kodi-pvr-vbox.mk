################################################################################
#
# kodi-pvr-vbox
#
################################################################################

KODI_PVR_VBOX_VERSION = 874eb8812db1dd1b2626ed6c9f8391790f0e6818
KODI_PVR_VBOX_SITE = $(call github,kodi-pvr,pvr.vbox,$(KODI_PVR_VBOX_VERSION))
KODI_PVR_VBOX_LICENSE = GPLv2+
KODI_PVR_VBOX_LICENSE_FILES = src/client.h
KODI_PVR_VBOX_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
