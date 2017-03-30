################################################################################
#
# kodi-audiodecoder-timidity
#
################################################################################

KODI_AUDIODECODER_TIMIDITY_VERSION = a84559da92aa67744069fc9e9dc885732588c8ce
KODI_AUDIODECODER_TIMIDITY_SITE = $(call github,notspiff,audiodecoder.timidity,$(KODI_AUDIODECODER_TIMIDITY_VERSION))
KODI_AUDIODECODER_TIMIDITY_LICENSE = GPL-2.0+
KODI_AUDIODECODER_TIMIDITY_LICENSE_FILES = src/TimidityCodec.cpp
KODI_AUDIODECODER_TIMIDITY_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
