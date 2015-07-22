################################################################################
#
# kodi-audioencoder-flac
#
################################################################################

KODI_AUDIOENCODER_FLAC_VERSION = a5e2d1262de3b2de567cf0a8207636ebaacb8775
KODI_AUDIOENCODER_FLAC_SITE = $(call github,xbmc,audioencoder.flac,$(KODI_AUDIOENCODER_FLAC_VERSION))
KODI_AUDIOENCODER_FLAC_LICENSE = GPLv2+
KODI_AUDIOENCODER_FLAC_LICENSE_FILES = src/EncoderFlac.cpp
KODI_AUDIOENCODER_FLAC_DEPENDENCIES = flac kodi libogg
KODI_AUDIOENCODER_FLAC_CONF_OPTS += \
	-DFLAC_INCLUDE_DIRS=$(STAGING_DIR)/usr/include \
	-DOGG_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

$(eval $(cmake-package))
