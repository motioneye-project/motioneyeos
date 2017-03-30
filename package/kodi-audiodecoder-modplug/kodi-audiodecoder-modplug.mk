################################################################################
#
# kodi-audiodecoder-modplug
#
################################################################################

KODI_AUDIODECODER_MODPLUG_VERSION = 03b772da7ea44ff3c34b322989254cd1e4732443
KODI_AUDIODECODER_MODPLUG_SITE = $(call github,notspiff,audiodecoder.modplug,$(KODI_AUDIODECODER_MODPLUG_VERSION))
KODI_AUDIODECODER_MODPLUG_LICENSE = GPL-2.0+
KODI_AUDIODECODER_MODPLUG_LICENSE_FILES = src/ModplugCodec.cpp
KODI_AUDIODECODER_MODPLUG_DEPENDENCIES = kodi-platform libmodplug

$(eval $(cmake-package))
