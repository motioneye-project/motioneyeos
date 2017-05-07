################################################################################
#
# kodi-pvr-vuplus
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_VUPLUS_VERSION = 25c4883e7c73c71d77fd32c8e33284ed5f081287
KODI_PVR_VUPLUS_SITE = $(call github,kodi-pvr,pvr.vuplus,$(KODI_PVR_VUPLUS_VERSION))
KODI_PVR_VUPLUS_LICENSE = GPL-2.0+
KODI_PVR_VUPLUS_LICENSE_FILES = src/client.h
KODI_PVR_VUPLUS_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
