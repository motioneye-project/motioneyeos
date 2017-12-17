################################################################################
#
# kodi-audiodecoder-opus
#
################################################################################

KODI_AUDIODECODER_OPUS_VERSION = 0bd11e35e6ed8b6480e4100ac8927113cb085eda
KODI_AUDIODECODER_OPUS_SITE = $(call github,notspiff,audiodecoder.opus,$(KODI_AUDIODECODER_OPUS_VERSION))
KODI_AUDIODECODER_OPUS_LICENSE = GPLv2+
KODI_AUDIODECODER_OPUS_LICENSE_FILES = src/OpusCodec.cpp
KODI_AUDIODECODER_OPUS_DEPENDENCIES = kodi-platform libogg opus opusfile

$(eval $(cmake-package))
