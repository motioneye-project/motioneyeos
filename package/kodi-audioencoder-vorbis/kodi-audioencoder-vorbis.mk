################################################################################
#
# kodi-audioencoder-vorbis
#
################################################################################

KODI_AUDIOENCODER_VORBIS_VERSION = d556a6872e59806526f208e8d0af5f886a6c67bb
KODI_AUDIOENCODER_VORBIS_SITE = $(call github,xbmc,audioencoder.vorbis,$(KODI_AUDIOENCODER_VORBIS_VERSION))
KODI_AUDIOENCODER_VORBIS_LICENSE = GPLv2+
KODI_AUDIOENCODER_VORBIS_LICENSE_FILES = src/EncoderVorbis.cpp
KODI_AUDIOENCODER_VORBIS_DEPENDENCIES = kodi libogg libvorbis
KODI_AUDIOENCODER_VORBIS_CONF_OPTS += \
	-DCMAKE_MODULE_PATH=$(STAGING_DIR)/usr/lib/kodi \
	-DOGG_INCLUDE_DIRS=$(STAGING_DIR)/usr/include \
	-DVORBIS_INCLUDE_DIRS=$(STAGING_DIR)/usr/include \
	-DVORBISENC_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

$(eval $(cmake-package))
