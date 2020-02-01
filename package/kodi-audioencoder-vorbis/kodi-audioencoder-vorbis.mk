################################################################################
#
# kodi-audioencoder-vorbis
#
################################################################################

KODI_AUDIOENCODER_VORBIS_VERSION = 2.0.3-Leia
KODI_AUDIOENCODER_VORBIS_SITE = $(call github,xbmc,audioencoder.vorbis,$(KODI_AUDIOENCODER_VORBIS_VERSION))
KODI_AUDIOENCODER_VORBIS_LICENSE = GPL-2.0+
KODI_AUDIOENCODER_VORBIS_LICENSE_FILES = src/EncoderVorbis.cpp
KODI_AUDIOENCODER_VORBIS_DEPENDENCIES = kodi libogg libvorbis host-pkgconf

$(eval $(cmake-package))
