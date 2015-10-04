################################################################################
#
# kodi-audiodecoder-modplug
#
################################################################################

KODI_AUDIODECODER_MODPLUG_VERSION = 5ae7349f39a8e5552c86dfdad339fb18c7e52550
KODI_AUDIODECODER_MODPLUG_SITE = $(call github,notspiff,audiodecoder.modplug,$(KODI_AUDIODECODER_MODPLUG_VERSION))
KODI_AUDIODECODER_MODPLUG_LICENSE = GPLv2+
KODI_AUDIODECODER_MODPLUG_LICENSE_FILES = src/ModplugCodec.cpp
KODI_AUDIODECODER_MODPLUG_DEPENDENCIES = kodi-platform libmodplug

$(eval $(cmake-package))
