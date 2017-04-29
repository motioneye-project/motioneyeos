################################################################################
#
# kodi-audiodecoder-snesapu
#
################################################################################

KODI_AUDIODECODER_SNESAPU_VERSION = v1.1.0
KODI_AUDIODECODER_SNESAPU_SITE = $(call github,notspiff,audiodecoder.snesapu,$(KODI_AUDIODECODER_SNESAPU_VERSION))
KODI_AUDIODECODER_SNESAPU_LICENSE = GPL-2.0+
KODI_AUDIODECODER_SNESAPU_LICENSE_FILES = src/SPCCodec.cpp
KODI_AUDIODECODER_SNESAPU_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
