################################################################################
#
# kodi-pvr-vuplus
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_VUPLUS_VERSION = 84ee66d16479dd8c9a65868af427670d9e9d02aa
KODI_PVR_VUPLUS_SITE = $(call github,kodi-pvr,pvr.vuplus,$(KODI_PVR_VUPLUS_VERSION))
KODI_PVR_VUPLUS_LICENSE = GPLv2+
KODI_PVR_VUPLUS_LICENSE_FILES = src/client.h
KODI_PVR_VUPLUS_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
