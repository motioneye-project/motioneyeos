################################################################################
#
# kodi-inputstream-adaptive
#
################################################################################

KODI_INPUTSTREAM_ADAPTIVE_VERSION = 1.0.8_k17
KODI_INPUTSTREAM_ADAPTIVE_SITE = $(call github,peak3d,inputstream.adaptive,$(KODI_INPUTSTREAM_ADAPTIVE_VERSION))
KODI_INPUTSTREAM_ADAPTIVE_LICENSE = GPL-2.0+
KODI_INPUTSTREAM_ADAPTIVE_LICENSE_FILES = src/main.cpp
KODI_INPUTSTREAM_ADAPTIVE_DEPENDENCIES = libplatform kodi-platform

$(eval $(cmake-package))
