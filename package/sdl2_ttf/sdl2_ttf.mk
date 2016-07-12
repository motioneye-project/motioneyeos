################################################################################
#
# sdl2_ttf
#
################################################################################

SDL2_TTF_VERSION = 2.0.14
SDL2_TTF_SOURCE = SDL2_ttf-$(SDL2_TTF_VERSION).tar.gz
SDL2_TTF_SITE = http://www.libsdl.org/projects/SDL_ttf/release
SDL2_TTF_LICENSE = zlib
SDL2_TTF_LICENSE_FILES = COPYING.txt
SDL2_TTF_INSTALL_STAGING = YES
SDL2_TTF_DEPENDENCIES = sdl2 freetype host-pkgconf
SDL2_TTF_CONF_ENV = \
	FREETYPE_CONFIG=$(STAGING_DIR)/usr/bin/freetype-config

$(eval $(autotools-package))
