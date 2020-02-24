################################################################################
#
# fluidsynth
#
################################################################################

FLUIDSYNTH_VERSION = 2.1.1
FLUIDSYNTH_SITE = $(call github,FluidSynth,fluidsynth,v$(FLUIDSYNTH_VERSION))
FLUIDSYNTH_LICENSE = LGPL-2.1+
FLUIDSYNTH_LICENSE_FILES = LICENSE
FLUIDSYNTH_INSTALL_STAGING = YES
FLUIDSYNTH_DEPENDENCIES = libglib2

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_ALSA_LIB),y)
FLUIDSYNTH_CONF_OPTS += -Denable-alsa=1
FLUIDSYNTH_DEPENDENCIES += alsa-lib
else
FLUIDSYNTH_CONF_OPTS += -Denable-alsa=0
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_DBUS),y)
FLUIDSYNTH_CONF_OPTS += -Denable-dbus=1
FLUIDSYNTH_DEPENDENCIES += dbus
else
FLUIDSYNTH_CONF_OPTS += -Denable-dbus=0
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_FLOATS),y)
FLUIDSYNTH_CONF_OPTS += -Denable-floats=1
else
FLUIDSYNTH_CONF_OPTS += -Denable-floats=0
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_JACK2),y)
FLUIDSYNTH_CONF_OPTS += -Denable-jack=1
FLUIDSYNTH_DEPENDENCIES += jack2
else
FLUIDSYNTH_CONF_OPTS += -Denable-jack=0
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_LIBSNDFILE),y)
FLUIDSYNTH_CONF_OPTS += -Denable-libsndfile=1
FLUIDSYNTH_DEPENDENCIES += libsndfile
else
FLUIDSYNTH_CONF_OPTS += -Denable-libsndfile=0
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_PORTAUDIO),y)
FLUIDSYNTH_CONF_OPTS += -Denable-portaudio=1
FLUIDSYNTH_DEPENDENCIES += portaudio
else
FLUIDSYNTH_CONF_OPTS += -Denable-portaudio=0
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_PULSEAUDIO),y)
FLUIDSYNTH_CONF_OPTS += -Denable-pulseaudio=1
FLUIDSYNTH_DEPENDENCIES += pulseaudio
else
FLUIDSYNTH_CONF_OPTS += -Denable-pulseaudio=0
endif

ifeq ($(BR2_PACKAGE_FLUIDSYNTH_READLINE),y)
FLUIDSYNTH_CONF_OPTS += -Denable-readline=1
FLUIDSYNTH_DEPENDENCIES += readline
else
FLUIDSYNTH_CONF_OPTS += -Denable-readline=0
endif

$(eval $(cmake-package))
