################################################################################
#
# kodi-pvr-argustv
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_ARGUSTV_VERSION = ebce517b04e184adc13c4780cc3e76487448b79b
KODI_PVR_ARGUSTV_SITE = $(call github,kodi-pvr,pvr.argustv,$(KODI_PVR_ARGUSTV_VERSION))
KODI_PVR_ARGUSTV_LICENSE = GPLv2+
KODI_PVR_ARGUSTV_LICENSE_FILES = src/client.h
KODI_PVR_ARGUSTV_DEPENDENCIES = jsoncpp kodi-platform

$(eval $(cmake-package))
