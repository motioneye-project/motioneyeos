################################################################################
#
# kodi-inputstream-adaptive
#
################################################################################

# This cset is on the branch 'Krypton'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_INPUTSTREAM_ADAPTIVE_VERSION = f2904b547e940c724dce7412a26744c2698cab66
KODI_INPUTSTREAM_ADAPTIVE_SITE = $(call github,peak3d,inputstream.adaptive,$(KODI_INPUTSTREAM_ADAPTIVE_VERSION))
KODI_INPUTSTREAM_ADAPTIVE_LICENSE = GPL-2.0+
KODI_INPUTSTREAM_ADAPTIVE_LICENSE_FILES = src/main.cpp
KODI_INPUTSTREAM_ADAPTIVE_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
