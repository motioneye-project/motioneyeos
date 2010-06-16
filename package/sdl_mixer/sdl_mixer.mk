#############################################################
#
# SDL_mixer
#
#############################################################
SDL_MIXER_VERSION:=1.2.11
SDL_MIXER_SOURCE:=SDL_mixer-$(SDL_MIXER_VERSION).tar.gz
SDL_MIXER_SITE:=http://www.libsdl.org/projects/SDL_mixer/release/

SDL_MIXER_LIBTOOL_PATCH = NO
SDL_MIXER_INSTALL_STAGING = YES
SDL_MIXER_DEPENDENCIES = sdl
SDL_MIXER_CONF_OPT = --without-x --with-sdl-prefix=$(STAGING_DIR)/usr

define SDL_MIXER_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libSDL_mixer*.so* $(TARGET_DIR)/usr/lib/
endef

define SDL_MIXER_CLEAN_CMDS
	rm -f $(TARGET_DIR)/usr/lib/libSDL_mixer*.so*
	-$(MAKE) DESTDIR=$(STAGING_DIR) -C $(@D) uninstall
	-$(MAKE) -C $(@D) clean
endef

$(eval $(call AUTOTARGETS,package,sdl_mixer))
