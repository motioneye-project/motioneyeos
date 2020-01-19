################################################################################
#
# kodi-audiodecoder-nosefart
#
################################################################################

KODI_AUDIODECODER_NOSEFART_VERSION = 2.0.1-Leia
KODI_AUDIODECODER_NOSEFART_SITE = $(call github,xbmc,audiodecoder.nosefart,$(KODI_AUDIODECODER_NOSEFART_VERSION))
KODI_AUDIODECODER_NOSEFART_LICENSE = GPL-2.0+
KODI_AUDIODECODER_NOSEFART_LICENSE_FILES = src/NSFCodec.cpp
KODI_AUDIODECODER_NOSEFART_DEPENDENCIES = kodi

$(eval $(cmake-package))
