################################################################################
#
# kodi-pvr-njoy
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_NJOY_VERSION = 2.4.3-Krypton
KODI_PVR_NJOY_SITE = $(call github,kodi-pvr,pvr.njoy,$(KODI_PVR_NJOY_VERSION))
KODI_PVR_NJOY_LICENSE = GPL-2.0+
KODI_PVR_NJOY_LICENSE_FILES = src/client.h
KODI_PVR_NJOY_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
