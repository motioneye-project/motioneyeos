################################################################################
#
# kodi-inputstream-adaptive
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_INPUTSTREAM_ADAPTIVE_VERSION = 9af21218a87572bd4ab8d8d660c11f6295144f97
KODI_INPUTSTREAM_ADAPTIVE_SITE = $(call github,peak3d,inputstream.adaptive,$(KODI_INPUTSTREAM_ADAPTIVE_VERSION))
KODI_INPUTSTREAM_ADAPTIVE_LICENSE = GPL-2.0+
KODI_INPUTSTREAM_ADAPTIVE_LICENSE_FILES = src/main.cpp
KODI_INPUTSTREAM_ADAPTIVE_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
