#############################################################
#
# mpg123
#
#############################################################

MPG123_VERSION = 1.14.2
MPG123_SOURCE = mpg123-$(MPG123_VERSION).tar.bz2
MPG123_SITE = http://downloads.sourceforge.net/project/mpg123/mpg123/$(MPG123_VERSION)
MPG123_CONF_OPT = --with-optimization=0 --disable-lfs-alias
MPG123_INSTALL_STAGING = YES

MPG123_CPU = $(if $(BR2_SOFT_FLOAT),generic_nofpu,generic_fpu)

ifeq ($(BR2_arm),y)
MPG123_CPU = arm_nofpu
endif

ifeq ($(BR2_i386),y)
MPG123_CPU = x86
endif

ifeq ($(BR2_powerpc),y)
ifneq ($(BR2_powerpc_7400)$(BR2_powerpc_7450)$(BR2_powerpc_970),)
MPG123_CPU = altivec
endif
ifeq ($(BR2_SOFT_FLOAT),y)
MPG123_CPU = ppc_nofpu
endif
endif

ifeq ($(BR2_x86_64),y)
MPG123_CPU = x86-64
endif

MPG123_CONF_OPT += --with-cpu=$(MPG123_CPU)

MPG123_AUDIO = dummy oss

ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
MPG123_AUDIO += portaudio
MPG123_CONF_OPT += --with-default-audio=portaudio
MPG123_DEPENDENCIES += portaudio
endif

ifeq ($(BR2_PACKAGE_SDL),y)
MPG123_AUDIO += sdl
MPG123_CONF_OPT += --with-default-audio=sdl
MPG123_DEPENDENCIES += sdl
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
MPG123_AUDIO += alsa
MPG123_CONF_OPT += --with-default-audio=alsa
MPG123_DEPENDENCIES += alsa-lib
endif

MPG123_CONF_OPT += --with-audio=$(shell echo $(MPG123_AUDIO) | tr ' ' ,)

ifeq ($(BR2_PACKAGE_LIBTOOL),y)
MPG123_DEPENDENCIES += libtool
# .la files gets stripped unless HAVE_DEVFILES is enabled, so directly
# load .so files rather than .la
MPG123_CONF_OPT += --with-modules --with-module-suffix=.so
endif

$(eval $(autotools-package))
