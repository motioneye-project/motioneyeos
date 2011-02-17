#############################################################
#
# SDL_gfx addon for SDL
#
#############################################################
SDL_GFX_VERSION:=2.0.19
SDL_GFX_SOURCE:=SDL_gfx-$(SDL_GFX_VERSION).tar.gz
SDL_GFX_SITE:=http://www.ferzkopp.net/Software/SDL_gfx-2.0/
SDL_GFX_INSTALL_STAGING:=YES
SDL_GFX_INSTALL_TARGET:=YES

SDL_GFX_DEPENDENCIES:=sdl

SDL_GFX_CONF_OPT = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--disable-sdltest \
	--enable-static

# enable mmx for newer x86's
ifeq ($(BR2_i386)$(BR2_x86_i386)$(BR2_x86_i486)$(BR2_x86_i586)$(BR2_x86_pentiumpro)$(BR2_x86_geode),y)
SDL_GFX_CONF_OPT += --enable-mmx
else
SDL_GFX_CONF_OPT += --disable-mmx
endif

$(eval $(call AUTOTARGETS,package,sdl_gfx))
