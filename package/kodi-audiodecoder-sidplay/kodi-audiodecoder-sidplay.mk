################################################################################
#
# kodi-audiodecoder-sidplay
#
################################################################################

KODI_AUDIODECODER_SIDPLAY_VERSION = 1.2.1-Leia
KODI_AUDIODECODER_SIDPLAY_SITE = $(call github,xbmc,audiodecoder.sidplay,$(KODI_AUDIODECODER_SIDPLAY_VERSION))
KODI_AUDIODECODER_SIDPLAY_LICENSE = GPL-2.0+
KODI_AUDIODECODER_SIDPLAY_LICENSE_FILES = src/SIDCodec.cpp
KODI_AUDIODECODER_SIDPLAY_DEPENDENCIES = host-pkgconf kodi libsidplay2

$(eval $(cmake-package))
