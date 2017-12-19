################################################################################
#
# kodi-audiodecoder-vgmstream
#
################################################################################

KODI_AUDIODECODER_VGMSTREAM_VERSION = v1.1.0
KODI_AUDIODECODER_VGMSTREAM_SITE = $(call github,notspiff,audiodecoder.vgmstream,$(KODI_AUDIODECODER_VGMSTREAM_VERSION))
KODI_AUDIODECODER_VGMSTREAM_LICENSE = GPL-2.0+
KODI_AUDIODECODER_VGMSTREAM_LICENSE_FILES = src/VGMCodec.cpp
KODI_AUDIODECODER_VGMSTREAM_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
