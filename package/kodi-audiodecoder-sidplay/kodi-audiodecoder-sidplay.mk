################################################################################
#
# kodi-audiodecoder-sidplay
#
################################################################################

KODI_AUDIODECODER_SIDPLAY_VERSION = v1.1.0
KODI_AUDIODECODER_SIDPLAY_SITE = $(call github,notspiff,audiodecoder.sidplay,$(KODI_AUDIODECODER_SIDPLAY_VERSION))
KODI_AUDIODECODER_SIDPLAY_LICENSE = GPL-2.0+
KODI_AUDIODECODER_SIDPLAY_LICENSE_FILES = src/SIDCodec.cpp
KODI_AUDIODECODER_SIDPLAY_DEPENDENCIES = host-pkgconf kodi-platform libsidplay2

$(eval $(cmake-package))
