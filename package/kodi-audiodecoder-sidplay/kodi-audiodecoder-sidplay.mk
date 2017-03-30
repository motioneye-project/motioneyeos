################################################################################
#
# kodi-audiodecoder-sidplay
#
################################################################################

KODI_AUDIODECODER_SIDPLAY_VERSION = d832f050211b4e5f085a8b09bc7d26ce32098169
KODI_AUDIODECODER_SIDPLAY_SITE = $(call github,notspiff,audiodecoder.sidplay,$(KODI_AUDIODECODER_SIDPLAY_VERSION))
KODI_AUDIODECODER_SIDPLAY_LICENSE = GPL-2.0+
KODI_AUDIODECODER_SIDPLAY_LICENSE_FILES = src/SIDCodec.cpp
KODI_AUDIODECODER_SIDPLAY_DEPENDENCIES = host-pkgconf kodi-platform libsidplay2

$(eval $(cmake-package))
