################################################################################
#
# kodi-audioencoder-vorbis
#
################################################################################

KODI_AUDIOENCODER_VORBIS_VERSION = 787d4a048be7fe8191afda8005a209976724dda1
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
