################################################################################
#
# kodi-audioencoder-wav
#
################################################################################

KODI_AUDIOENCODER_WAV_VERSION = 40aaedfa1cd9c75749c82f6e1bd7c42ef61fdb38
KODI_AUDIOENCODER_WAV_SITE = $(call github,xbmc,audioencoder.wav,$(KODI_AUDIOENCODER_WAV_VERSION))
KODI_AUDIOENCODER_WAV_LICENSE = GPLv2+
KODI_AUDIOENCODER_WAV_LICENSE_FILES = src/EncoderWav.cpp
KODI_AUDIOENCODER_WAV_DEPENDENCIES = kodi
KODI_AUDIOENCODER_WAV_CONF_OPTS += \
	-DCMAKE_MODULE_PATH=$(STAGING_DIR)/usr/lib/kodi

$(eval $(cmake-package))
