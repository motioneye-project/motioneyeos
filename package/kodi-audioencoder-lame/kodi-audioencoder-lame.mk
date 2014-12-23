################################################################################
#
# kodi-audioencoder-lame
#
################################################################################

KODI_AUDIOENCODER_LAME_VERSION = 6f8384f0d003faf7b91dcd38357ea0ecf9030cce
KODI_AUDIOENCODER_LAME_SITE = $(call github,xbmc,audioencoder.lame,$(KODI_AUDIOENCODER_LAME_VERSION))
KODI_AUDIOENCODER_LAME_LICENSE = GPLv2+
KODI_AUDIOENCODER_LAME_LICENSE_FILES = src/EncoderLame.cpp
KODI_AUDIOENCODER_LAME_DEPENDENCIES = kodi lame
KODI_AUDIOENCODER_LAME_CONF_OPTS += \
	-DCMAKE_MODULE_PATH=$(STAGING_DIR)/usr/lib/kodi \
	-DLAME_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

$(eval $(cmake-package))
