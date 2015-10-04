################################################################################
#
# kodi-pvr-iptvsimple
#
################################################################################

KODI_PVR_IPTVSIMPLE_VERSION = 23defebace9a596d549a688c1d017900aeaf7761
KODI_PVR_IPTVSIMPLE_SITE = $(call github,kodi-pvr,pvr.iptvsimple,$(KODI_PVR_IPTVSIMPLE_VERSION))
KODI_PVR_IPTVSIMPLE_LICENSE = GPLv2+
KODI_PVR_IPTVSIMPLE_LICENSE_FILES = src/client.h
KODI_PVR_IPTVSIMPLE_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
