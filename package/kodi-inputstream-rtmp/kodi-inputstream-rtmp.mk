################################################################################
#
# kodi-inputstream-rtmp
#
################################################################################

KODI_INPUTSTREAM_RTMP_VERSION = d93d32d45dfa61ad4b27f166f08736bd416bc329
KODI_INPUTSTREAM_RTMP_SITE = $(call github,notspiff,inputstream.rtmp,$(KODI_INPUTSTREAM_RTMP_VERSION))
KODI_INPUTSTREAM_RTMP_LICENSE = GPL-2.0+
KODI_INPUTSTREAM_RTMP_LICENSE_FILES = src/RTMPStream.cpp
KODI_INPUTSTREAM_RTMP_DEPENDENCIES = kodi rtmpdump

$(eval $(cmake-package))
