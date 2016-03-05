################################################################################
#
# kodi-audioencoder-flac
#
################################################################################

KODI_AUDIOENCODER_FLAC_VERSION = 8e6718508bb9169d614c1fd5ee0e3de02af3b548
KODI_AUDIOENCODER_FLAC_SITE = $(call github,xbmc,audioencoder.flac,$(KODI_AUDIOENCODER_FLAC_VERSION))
KODI_AUDIOENCODER_FLAC_LICENSE = GPLv2+
KODI_AUDIOENCODER_FLAC_LICENSE_FILES = src/EncoderFlac.cpp
KODI_AUDIOENCODER_FLAC_DEPENDENCIES = flac kodi libogg host-pkgconf

$(eval $(cmake-package))
