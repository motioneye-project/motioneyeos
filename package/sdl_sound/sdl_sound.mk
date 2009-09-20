#############################################################
#
# sdl_sound addon for SDL
#
#############################################################
SDL_SOUND_VERSION:=1.0.3
SDL_SOUND_SOURCE:=SDL_sound-$(SDL_SOUND_VERSION).tar.gz
SDL_SOUND_SITE:=http://icculus.org/SDL_sound/downloads/
SDL_SOUND_LIBTOOL_PATCH:=NO
SDL_SOUND_INSTALL_STAGING:=YES
SDL_SOUND_INSTALL_TARGET:=YES

SDL_SOUND_CONF_OPT:=--with-sdl-prefix=$(STAGING_DIR)/usr \
		--with-sdl-exec-prefix=$(STAGING_DIR)/usr \
		--disable-sdltest \
		--enable-static \
		--program-prefix=''

# enable mmx for newer x86's
ifeq ($(BR2_i386)$(BR2_x86_i386)$(BR2_x86_i486)$(BR2_x86_i586)$(BR2_x86_pentiumpro)$(BR2_x86_geode),y)
SDL_SOUND_CONF_OPT += --enable-mmx
else
SDL_SOUND_CONF_OPT += --disable-mmx
endif

$(eval $(call AUTOTARGETS,package,sdl_sound))

ifneq ($(BR2_PACKAGE_SDL_SOUND_PLAYSOUND),y)
$(SDL_SOUND_HOOK_POST_INSTALL):
	rm $(addprefix $(TARGET_DIR)/usr/bin/,playsound playsound_simple)
	touch $@
endif

# target shared libs doesn't get removed by make uninstall if the .la files
# are removed (E.G. if BR2_HAVE_DEVFILES isn't set)
$(SDL_SOUND_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	$(MAKE) DESTDIR=$(STAGING_DIR) uninstall -C $(@D)/$(SDL_SOUND_SUBDIR)
	rm -f $(@D)/.stamp_staging_installed
	$(MAKE) DESTDIR=$(TARGET_DIR) uninstall -C $(@D)/$(SDL_SOUND_SUBDIR)
	rm -f $(TARGET_DIR)/usr/lib/libSDL_sound*so*
	rm -f $(SDL_SOUND_TARGET_INSTALL_TARGET) $(SDL_SOUND_HOOK_POST_INSTALL)
