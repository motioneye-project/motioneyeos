################################################################################
#
# kodi-audiodecoder-snesapu
#
################################################################################

KODI_AUDIODECODER_SNESAPU_VERSION = 2.0.1-Leia
KODI_AUDIODECODER_SNESAPU_SITE = $(call github,xbmc,audiodecoder.snesapu,$(KODI_AUDIODECODER_SNESAPU_VERSION))
KODI_AUDIODECODER_SNESAPU_LICENSE = GPL-2.0+
KODI_AUDIODECODER_SNESAPU_LICENSE_FILES = src/SPCCodec.cpp
KODI_AUDIODECODER_SNESAPU_DEPENDENCIES = kodi

$(eval $(cmake-package))
