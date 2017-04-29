################################################################################
#
# kodi-audiodecoder-opus
#
################################################################################

KODI_AUDIODECODER_OPUS_VERSION = d6eb25f0c08033f9a2b4d7402e8baf866ebc731c
KODI_AUDIODECODER_OPUS_SITE = $(call github,notspiff,audiodecoder.opus,$(KODI_AUDIODECODER_OPUS_VERSION))
KODI_AUDIODECODER_OPUS_LICENSE = GPL-2.0+
KODI_AUDIODECODER_OPUS_LICENSE_FILES = src/OpusCodec.cpp
KODI_AUDIODECODER_OPUS_DEPENDENCIES = kodi-platform libogg opus opusfile

$(eval $(cmake-package))
