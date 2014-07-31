################################################################################
#
# webrtc-audio-processing
#
################################################################################

WEBRTC_AUDIO_PROCESSING_VERSION = 0.1
WEBRTC_AUDIO_PROCESSING_SOURCE = webrtc-audio-processing-$(WEBRTC_AUDIO_PROCESSING_VERSION).tar.xz
WEBRTC_AUDIO_PROCESSING_SITE = http://freedesktop.org/software/pulseaudio/webrtc-audio-processing
WEBRTC_AUDIO_PROCESSING_INSTALL_STAGING = YES
WEBRTC_AUDIO_PROCESSING_LICENSE = BSD-3c
WEBRTC_AUDIO_PROCESSING_LICENSE_FILES = COPYING

ifeq ($(BR2_SOFT_FLOAT),y)
WEBRTC_AUDIO_PROCESSING_CONF_OPT += --with-ns-mode=fixed
endif

$(eval $(autotools-package))
