################################################################################
#
# kodi-audioencoder-wav
#
################################################################################

KODI_AUDIOENCODER_WAV_VERSION = 2.0.3-Leia
KODI_AUDIOENCODER_WAV_SITE = $(call github,xbmc,audioencoder.wav,$(KODI_AUDIOENCODER_WAV_VERSION))
KODI_AUDIOENCODER_WAV_LICENSE = GPL-2.0+
KODI_AUDIOENCODER_WAV_LICENSE_FILES = debian/copyright
KODI_AUDIOENCODER_WAV_DEPENDENCIES = kodi

$(eval $(cmake-package))
