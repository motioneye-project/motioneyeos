################################################################################
#
# kodi-audiodecoder-timidity
#
################################################################################

KODI_AUDIODECODER_TIMIDITY_VERSION = da5eb9ac6557fc1ea0f48cc044cfd16f4f2a1e0b
KODI_AUDIODECODER_TIMIDITY_SITE = $(call github,notspiff,audiodecoder.timidity,$(KODI_AUDIODECODER_TIMIDITY_VERSION))
KODI_AUDIODECODER_TIMIDITY_LICENSE = GPLv2+
KODI_AUDIODECODER_TIMIDITY_LICENSE_FILES = src/TimidityCodec.cpp
KODI_AUDIODECODER_TIMIDITY_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
