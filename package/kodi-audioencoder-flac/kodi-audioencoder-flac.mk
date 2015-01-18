################################################################################
#
# kodi-audioencoder-flac
#
################################################################################

KODI_AUDIOENCODER_FLAC_VERSION = 62c2cc876b572dd8fd9b85d708f86ec9a9d2ffc7
KODI_AUDIOENCODER_FLAC_SITE = $(call github,xbmc,audioencoder.flac,$(KODI_AUDIOENCODER_FLAC_VERSION))
KODI_AUDIOENCODER_FLAC_LICENSE = GPLv2+
KODI_AUDIOENCODER_FLAC_LICENSE_FILES = src/EncoderFlac.cpp
KODI_AUDIOENCODER_FLAC_DEPENDENCIES = flac kodi libogg
KODI_AUDIOENCODER_FLAC_CONF_OPTS += \
	-DCMAKE_MODULE_PATH=$(STAGING_DIR)/usr/lib/kodi \
	-DFLAC_INCLUDE_DIRS=$(STAGING_DIR)/usr/include \
	-DOGG_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

$(eval $(cmake-package))
