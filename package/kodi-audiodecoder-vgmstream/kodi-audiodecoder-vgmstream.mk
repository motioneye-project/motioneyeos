################################################################################
#
# kodi-audiodecoder-vgmstream
#
################################################################################

KODI_AUDIODECODER_VGMSTREAM_VERSION = cb2892ac0465b0563ee45f532323198a6f722b62
KODI_AUDIODECODER_VGMSTREAM_SITE = $(call github,notspiff,audiodecoder.vgmstream,$(KODI_AUDIODECODER_VGMSTREAM_VERSION))
KODI_AUDIODECODER_VGMSTREAM_LICENSE = GPL-2.0+
KODI_AUDIODECODER_VGMSTREAM_LICENSE_FILES = src/VGMCodec.cpp
KODI_AUDIODECODER_VGMSTREAM_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
