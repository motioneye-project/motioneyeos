################################################################################
#
# kodi-audioencoder-wav
#
################################################################################

KODI_AUDIOENCODER_WAV_VERSION = 797c990eea7851889cd44a597c0392deba9c51c0
KODI_AUDIOENCODER_WAV_SITE = $(call github,xbmc,audioencoder.wav,$(KODI_AUDIOENCODER_WAV_VERSION))
KODI_AUDIOENCODER_WAV_LICENSE = GPLv2+
KODI_AUDIOENCODER_WAV_LICENSE_FILES = src/EncoderWav.cpp
KODI_AUDIOENCODER_WAV_DEPENDENCIES = kodi

$(eval $(cmake-package))
