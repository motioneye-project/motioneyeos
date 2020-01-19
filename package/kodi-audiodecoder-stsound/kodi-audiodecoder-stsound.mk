################################################################################
#
# kodi-audiodecoder-stsound
#
################################################################################

KODI_AUDIODECODER_STSOUND_VERSION = 2.0.1-Leia
KODI_AUDIODECODER_STSOUND_SITE = $(call github,xbmc,audiodecoder.stsound,$(KODI_AUDIODECODER_STSOUND_VERSION))
KODI_AUDIODECODER_STSOUND_LICENSE = GPL-2.0+
KODI_AUDIODECODER_STSOUND_LICENSE_FILES = src/YMCodec.cpp
KODI_AUDIODECODER_STSOUND_DEPENDENCIES = kodi

$(eval $(cmake-package))
