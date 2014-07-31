################################################################################
#
# sdl_sound
#
################################################################################

SDL_SOUND_VERSION = 1.0.3
SDL_SOUND_SOURCE = SDL_sound-$(SDL_SOUND_VERSION).tar.gz
SDL_SOUND_SITE = http://icculus.org/SDL_sound/downloads
SDL_SOUND_LICENSE = LGPLv2.1+
SDL_SOUND_LICENSE_FILES = COPYING
SDL_SOUND_INSTALL_STAGING = YES
SDL_SOUND_DEPENDENCIES = sdl

ifneq ($(BR2_ENABLE_LOCALE),y)
SDL_SOUND_DEPENDENCIES += libiconv
endif

# optional dependencies
ifeq ($(BR2_PACKAGE_FLAC),y)
SDL_SOUND_DEPENDENCIES += flac # is only used if ogg is also enabled
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SDL_SOUND_DEPENDENCIES += libvorbis
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
SDL_SOUND_DEPENDENCIES += speex
endif

SDL_SOUND_CONF_OPT = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--with-sdl-exec-prefix=$(STAGING_DIR)/usr \
	--disable-sdltest \
	--enable-static

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
SDL_SOUND_CONF_OPT += --enable-mmx
else
SDL_SOUND_CONF_OPT += --disable-mmx
endif

define SDL_SOUND_REMOVE_PLAYSOUND
	rm $(addprefix $(TARGET_DIR)/usr/bin/,playsound playsound_simple)
endef

ifneq ($(BR2_PACKAGE_SDL_SOUND_PLAYSOUND),y)
SDL_SOUND_POST_INSTALL_TARGET_HOOKS += SDL_SOUND_REMOVE_PLAYSOUND
endif

$(eval $(autotools-package))
