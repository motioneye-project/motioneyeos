################################################################################
#
# webrtc-audio-processing
#
################################################################################

WEBRTC_AUDIO_PROCESSING_VERSION = 0.3
WEBRTC_AUDIO_PROCESSING_SOURCE = webrtc-audio-processing-$(WEBRTC_AUDIO_PROCESSING_VERSION).tar.xz
WEBRTC_AUDIO_PROCESSING_SITE = http://freedesktop.org/software/pulseaudio/webrtc-audio-processing
WEBRTC_AUDIO_PROCESSING_INSTALL_STAGING = YES
WEBRTC_AUDIO_PROCESSING_LICENSE = BSD-3c
WEBRTC_AUDIO_PROCESSING_LICENSE_FILES = COPYING
# 0001-configure.ac-fix-architecture-detection.patch
# 0002-Proper-detection-of-cxxabi.h-and-execinfo.h.patch
WEBRTC_AUDIO_PROCESSING_AUTORECONF = YES

ifeq ($(BR2_SOFT_FLOAT),y)
WEBRTC_AUDIO_PROCESSING_CONF_OPTS += --with-ns-mode=fixed
endif

$(eval $(autotools-package))
