################################################################################
#
# kodi-pvr-argustv
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_ARGUSTV_VERSION = 9040b1447bd622bcbae3f8944e7b84d933037644
KODI_PVR_ARGUSTV_SITE = $(call github,kodi-pvr,pvr.argustv,$(KODI_PVR_ARGUSTV_VERSION))
KODI_PVR_ARGUSTV_LICENSE = GPL-2.0+
KODI_PVR_ARGUSTV_LICENSE_FILES = src/client.h
KODI_PVR_ARGUSTV_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
