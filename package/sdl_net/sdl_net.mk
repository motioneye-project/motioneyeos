#############################################################
#
# SDL_net: network addon for SDL
#
#############################################################
SDL_NET_VERSION:=1.2.7
SDL_NET_SITE:=http://www.libsdl.org/projects/SDL_net/release

SDL_NET_CONF_OPT = --localstatedir=/var \
		--with-sdl-prefix=$(STAGING_DIR)/usr \
		--with-sdl-exec-prefix=$(STAGING_DIR)/usr

SDL_NET_INSTALL_STAGING = YES
SDL_NET_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install

SDL_NET_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

SDL_NET_DEPENDENCIES = sdl

$(eval $(call AUTOTARGETS,package,SDL_net))
