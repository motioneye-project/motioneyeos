################################################################################
#
# sdl_sound
#
################################################################################

SDL_SOUND_VERSION = 1.0.3
SDL_SOUND_SOURCE = SDL_sound-$(SDL_SOUND_VERSION).tar.gz
SDL_SOUND_SITE = http://icculus.org/SDL_sound/downloads
SDL_SOUND_LICENSE = LGPL-2.1+
SDL_SOUND_LICENSE_FILES = COPYING
SDL_SOUND_INSTALL_STAGING = YES
SDL_SOUND_DEPENDENCIES = sdl

ifneq ($(BR2_ENABLE_LOCALE),y)
SDL_SOUND_DEPENDENCIES += libiconv
endif

# optional dependencies
ifeq ($(BR2_PACKAGE_FLAC)$(BR2_PACKAGE_LIBOGG),yy)
SDL_SOUND_CONF_OPTS += --enable-flac
SDL_SOUND_DEPENDENCIES += flac libogg
else
SDL_SOUND_CONF_OPTS += --disable-flac
endif

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
SDL_SOUND_CONF_OPTS += --enable-modplug
SDL_SOUND_DEPENDENCIES += libmodplug
else
SDL_SOUND_CONF_OPTS += --disable-modplug
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SDL_SOUND_CONF_OPTS += --enable-ogg
SDL_SOUND_DEPENDENCIES += libvorbis
else
SDL_SOUND_CONF_OPTS += --disable-ogg
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
SDL_SOUND_CONF_OPTS += --enable-speex
SDL_SOUND_DEPENDENCIES += speex
else
SDL_SOUND_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_PHYSFS),y)
SDL_SOUND_CONF_OPTS += --enable-physfs
SDL_SOUND_DEPENDENCIES += physfs
else
SDL_SOUND_CONF_OPTS += --disable-physfs
endif

SDL_SOUND_CONF_OPTS = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--with-sdl-exec-prefix=$(STAGING_DIR)/usr \
	--disable-sdltest \
	--enable-static

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
SDL_SOUND_CONF_OPTS += --enable-mmx
else
SDL_SOUND_CONF_OPTS += --disable-mmx
endif

define SDL_SOUND_REMOVE_PLAYSOUND
	rm $(addprefix $(TARGET_DIR)/usr/bin/,playsound playsound_simple)
endef

ifneq ($(BR2_PACKAGE_SDL_SOUND_PLAYSOUND),y)
SDL_SOUND_POST_INSTALL_TARGET_HOOKS += SDL_SOUND_REMOVE_PLAYSOUND
endif

$(eval $(autotools-package))
