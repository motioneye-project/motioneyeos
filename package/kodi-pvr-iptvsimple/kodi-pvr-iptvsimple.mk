################################################################################
#
# kodi-pvr-iptvsimple
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_IPTVSIMPLE_VERSION = d7828163f26a0ccb175058faa9d87b1fcdc89220
KODI_PVR_IPTVSIMPLE_SITE = $(call github,kodi-pvr,pvr.iptvsimple,$(KODI_PVR_IPTVSIMPLE_VERSION))
KODI_PVR_IPTVSIMPLE_LICENSE = GPL-2.0+
KODI_PVR_IPTVSIMPLE_LICENSE_FILES = src/client.h
KODI_PVR_IPTVSIMPLE_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
