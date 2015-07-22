################################################################################
#
# kodi-audiodecoder-stsound
#
################################################################################

KODI_AUDIODECODER_STSOUND_VERSION = f6fbae94818fedd09e2f55c6cd1cb283bfdab6f4
KODI_AUDIODECODER_STSOUND_SITE = $(call github,notspiff,audiodecoder.stsound,$(KODI_AUDIODECODER_STSOUND_VERSION))
KODI_AUDIODECODER_STSOUND_LICENSE = GPLv2+
KODI_AUDIODECODER_STSOUND_LICENSE_FILES = src/YMCodec.cpp
KODI_AUDIODECODER_STSOUND_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
