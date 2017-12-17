################################################################################
#
# kodi-audiodecoder-snesapu
#
################################################################################

KODI_AUDIODECODER_SNESAPU_VERSION = db62e88e568994a0496d7026a10e044d70b3aa2b
KODI_AUDIODECODER_SNESAPU_SITE = $(call github,notspiff,audiodecoder.snesapu,$(KODI_AUDIODECODER_SNESAPU_VERSION))
KODI_AUDIODECODER_SNESAPU_LICENSE = GPLv2+
KODI_AUDIODECODER_SNESAPU_LICENSE_FILES = src/SPCCodec.cpp
KODI_AUDIODECODER_SNESAPU_DEPENDENCIES = kodi-platform

$(eval $(cmake-package))
