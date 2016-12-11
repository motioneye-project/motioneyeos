################################################################################
#
# mimic
#
################################################################################

MIMIC_VERSION = 1.1.0
MIMIC_SITE = $(call github,MycroftAI,mimic,$(MIMIC_VERSION))
MIMIC_LICENSE = MIT
MIMIC_LICENSE_FILES = COPYING

MIMIC_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_MIMIC_AUDIO_BACKEND_ALSA),y)
MIMIC_AUDIO_BACKEND = alsa
MIMIC_DEPENDENCIES += alsa-lib
else ifeq ($(BR2_PACKAGE_MIMIC_AUDIO_BACKEND_PORTAUDIO),y)
MIMIC_AUDIO_BACKEND = portaudio
MIMIC_DEPENDENCIES += portaudio
else ifeq ($(BR2_PACKAGE_MIMIC_AUDIO_BACKEND_PULSEAUDIO),y)
MIMIC_AUDIO_BACKEND = pulseaudio
MIMIC_DEPENDENCIES += pulseaudio
else ifeq ($(BR2_PACKAGE_MIMIC_AUDIO_BACKEND_NONE),y)
MIMIC_AUDIO_BACKEND = none
endif

MIMIC_CONF_OPTS += --with-audio=$(MIMIC_AUDIO_BACKEND)

$(eval $(autotools-package))
