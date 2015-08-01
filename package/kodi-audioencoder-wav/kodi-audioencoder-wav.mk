################################################################################
#
# kodi-audioencoder-wav
#
################################################################################

KODI_AUDIOENCODER_WAV_VERSION = 77e16122b132ca31b27d3602fd2d9ada214ff7f6
KODI_AUDIOENCODER_WAV_SITE = $(call github,xbmc,audioencoder.wav,$(KODI_AUDIOENCODER_WAV_VERSION))
KODI_AUDIOENCODER_WAV_LICENSE = GPLv2+
KODI_AUDIOENCODER_WAV_LICENSE_FILES = src/EncoderWav.cpp
KODI_AUDIOENCODER_WAV_DEPENDENCIES = kodi

$(eval $(cmake-package))
