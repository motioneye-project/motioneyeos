################################################################################
#
# mpg123
#
################################################################################

MPG123_VERSION = 1.25.10
MPG123_SOURCE = mpg123-$(MPG123_VERSION).tar.bz2
MPG123_SITE = http://downloads.sourceforge.net/project/mpg123/mpg123/$(MPG123_VERSION)
MPG123_CONF_OPTS = --disable-lfs-alias
MPG123_INSTALL_STAGING = YES
MPG123_LICENSE = LGPL-2.1
MPG123_LICENSE_FILES = COPYING
MPG123_DEPENDENCIES = host-pkgconf

MPG123_CPU = $(if $(BR2_SOFT_FLOAT),generic_nofpu,generic_fpu)

ifeq ($(BR2_aarch64),y)
MPG123_CPU = aarch64
endif

ifeq ($(BR2_arm),y)
ifeq ($(or $(BR2_ARM_CPU_HAS_NEON),$(BR2_ARM_CPU_HAS_VFPV2)),y)
MPG123_CPU = arm_fpu
else
MPG123_CPU = arm_nofpu
endif
endif

ifeq ($(BR2_i386),y)
MPG123_CPU = x86
endif

ifeq ($(BR2_powerpc),y)
ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
MPG123_CPU = altivec
endif
ifeq ($(BR2_SOFT_FLOAT),y)
MPG123_CPU = ppc_nofpu
endif
endif # powerpc

ifeq ($(BR2_x86_64),y)
MPG123_CPU = x86-64
endif

MPG123_CONF_OPTS += --with-cpu=$(MPG123_CPU)

MPG123_AUDIO = dummy oss

ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
MPG123_AUDIO += portaudio
MPG123_CONF_OPTS += --with-default-audio=portaudio
MPG123_DEPENDENCIES += portaudio
# configure script does NOT use pkg-config to figure out how to link
# with portaudio, breaking static linking as portaudio uses pthreads
MPG123_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs portaudio-2.0`"
endif

ifeq ($(BR2_PACKAGE_SDL),y)
MPG123_AUDIO += sdl
MPG123_CONF_OPTS += --with-default-audio=sdl
MPG123_DEPENDENCIES += sdl
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
MPG123_AUDIO += alsa
MPG123_CONF_OPTS += --with-default-audio=alsa
MPG123_DEPENDENCIES += alsa-lib
# configure script does NOT use pkg-config to figure out how to link
# with alsa, breaking static linking as alsa uses pthreads
MPG123_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs alsa`"
endif

MPG123_CONF_OPTS += --with-audio=$(subst $(space),$(comma),$(MPG123_AUDIO))

# output modules are loaded with dlopen()
ifeq ($(BR2_STATIC_LIBS),y)
MPG123_CONF_OPTS += --disable-modules
else
MPG123_CONF_OPTS += --enable-modules
endif

$(eval $(autotools-package))
