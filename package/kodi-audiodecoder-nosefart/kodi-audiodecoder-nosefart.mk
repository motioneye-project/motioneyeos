################################################################################
#
# kodi-audiodecoder-nosefart
#
################################################################################

KODI_AUDIODECODER_NOSEFART_VERSION = 936313f2be5c4936af8a643876363dcea76a8ebe
KODI_AUDIODECODER_NOSEFART_SITE = $(call github,notspiff,audiodecoder.nosefart,$(KODI_AUDIODECODER_NOSEFART_VERSION))
KODI_AUDIODECODER_NOSEFART_LICENSE = GPLv2+
KODI_AUDIODECODER_NOSEFART_LICENSE_FILES = src/NSFCodec.cpp
KODI_AUDIODECODER_NOSEFART_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
