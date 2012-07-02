#############################################################
#
# SDL_net: network addon for SDL
#
#############################################################
SDL_NET_VERSION = 1.2.8
SDL_NET_SITE = http://www.libsdl.org/projects/SDL_net/release
SDL_NET_SOURCE = SDL_net-$(SDL_NET_VERSION).tar.gz

SDL_NET_CONF_OPT = --localstatedir=/var \
		--with-sdl-prefix=$(STAGING_DIR)/usr \
		--with-sdl-exec-prefix=$(STAGING_DIR)/usr

SDL_NET_INSTALL_STAGING = YES

SDL_NET_DEPENDENCIES = sdl

$(eval $(autotools-package))
