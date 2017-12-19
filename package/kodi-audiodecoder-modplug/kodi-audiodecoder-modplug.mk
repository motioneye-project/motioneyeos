################################################################################
#
# kodi-audiodecoder-modplug
#
################################################################################

KODI_AUDIODECODER_MODPLUG_VERSION = v1.1.0
KODI_AUDIODECODER_MODPLUG_SITE = $(call github,notspiff,audiodecoder.modplug,$(KODI_AUDIODECODER_MODPLUG_VERSION))
KODI_AUDIODECODER_MODPLUG_LICENSE = GPL-2.0+
KODI_AUDIODECODER_MODPLUG_LICENSE_FILES = src/ModplugCodec.cpp
KODI_AUDIODECODER_MODPLUG_DEPENDENCIES = kodi-platform libmodplug

$(eval $(cmake-package))
