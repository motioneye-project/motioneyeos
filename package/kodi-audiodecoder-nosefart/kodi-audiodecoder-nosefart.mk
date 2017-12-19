################################################################################
#
# kodi-audiodecoder-nosefart
#
################################################################################

KODI_AUDIODECODER_NOSEFART_VERSION = v1.1.0
KODI_AUDIODECODER_NOSEFART_SITE = $(call github,notspiff,audiodecoder.nosefart,$(KODI_AUDIODECODER_NOSEFART_VERSION))
KODI_AUDIODECODER_NOSEFART_LICENSE = GPL-2.0+
KODI_AUDIODECODER_NOSEFART_LICENSE_FILES = src/NSFCodec.cpp
KODI_AUDIODECODER_NOSEFART_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
