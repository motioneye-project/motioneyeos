################################################################################
#
# kodi-audiodecoder-nosefart
#
################################################################################

KODI_AUDIODECODER_NOSEFART_VERSION = bfab543bae0d9855538cf03e78ea9cd5e3b9750e
KODI_AUDIODECODER_NOSEFART_SITE = $(call github,notspiff,audiodecoder.nosefart,$(KODI_AUDIODECODER_NOSEFART_VERSION))
KODI_AUDIODECODER_NOSEFART_LICENSE = GPLv2+
KODI_AUDIODECODER_NOSEFART_LICENSE_FILES = src/NSFCodec.cpp
KODI_AUDIODECODER_NOSEFART_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
