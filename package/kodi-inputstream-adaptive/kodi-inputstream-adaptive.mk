################################################################################
#
# kodi-inputstream-adaptive
#
################################################################################

KODI_INPUTSTREAM_ADAPTIVE_VERSION = 161f319bb2cd946f4659d841a54f19b1fb6143cc
KODI_INPUTSTREAM_ADAPTIVE_SITE = $(call github,peak3d,inputstream.adaptive,$(KODI_INPUTSTREAM_ADAPTIVE_VERSION))
KODI_INPUTSTREAM_ADAPTIVE_LICENSE = GPL-2.0+
KODI_INPUTSTREAM_ADAPTIVE_LICENSE_FILES = src/main.cpp
KODI_INPUTSTREAM_ADAPTIVE_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
