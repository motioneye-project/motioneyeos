################################################################################
#
# kodi-pvr-iptvsimple
#
################################################################################

# This cset is on the branch 'Jarvis'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_IPTVSIMPLE_VERSION = 824c6056b10c89913e1310d0c334206d32f5e1cf
KODI_PVR_IPTVSIMPLE_SITE = $(call github,kodi-pvr,pvr.iptvsimple,$(KODI_PVR_IPTVSIMPLE_VERSION))
KODI_PVR_IPTVSIMPLE_LICENSE = GPLv2+
KODI_PVR_IPTVSIMPLE_LICENSE_FILES = src/client.h
KODI_PVR_IPTVSIMPLE_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
