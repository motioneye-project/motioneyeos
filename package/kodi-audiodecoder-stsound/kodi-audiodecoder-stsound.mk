################################################################################
#
# kodi-audiodecoder-stsound
#
################################################################################

KODI_AUDIODECODER_STSOUND_VERSION = v1.1.0
KODI_AUDIODECODER_STSOUND_SITE = $(call github,notspiff,audiodecoder.stsound,$(KODI_AUDIODECODER_STSOUND_VERSION))
KODI_AUDIODECODER_STSOUND_LICENSE = GPL-2.0+
KODI_AUDIODECODER_STSOUND_LICENSE_FILES = src/YMCodec.cpp
KODI_AUDIODECODER_STSOUND_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
