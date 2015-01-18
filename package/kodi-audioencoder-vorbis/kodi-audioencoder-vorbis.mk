################################################################################
#
# kodi-audioencoder-vorbis
#
################################################################################

KODI_AUDIOENCODER_VORBIS_VERSION = dbf5c62c088283143c7ad530b106f3cc0c9392e9
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
