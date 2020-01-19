################################################################################
#
# kodi-audiodecoder-vgmstream
#
################################################################################

KODI_AUDIODECODER_VGMSTREAM_VERSION = 1.1.4-Leia
KODI_AUDIODECODER_VGMSTREAM_SITE = $(call github,xbmc,audiodecoder.vgmstream,$(KODI_AUDIODECODER_VGMSTREAM_VERSION))
KODI_AUDIODECODER_VGMSTREAM_LICENSE = GPL-2.0+
KODI_AUDIODECODER_VGMSTREAM_LICENSE_FILES = src/VGMCodec.cpp
KODI_AUDIODECODER_VGMSTREAM_DEPENDENCIES = kodi

$(eval $(cmake-package))
