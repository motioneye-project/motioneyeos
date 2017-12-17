################################################################################
#
# sdl2_ttf
#
################################################################################

SDL2_TTF_VERSION = 2.0.14
SDL2_TTF_SOURCE = SDL2_ttf-$(SDL2_TTF_VERSION).tar.gz
SDL2_TTF_SITE = http://www.libsdl.org/projects/SDL_ttf/release
SDL2_TTF_LICENSE = Zlib
SDL2_TTF_LICENSE_FILES = COPYING.txt
SDL2_TTF_INSTALL_STAGING = YES
SDL2_TTF_DEPENDENCIES = sdl2 freetype host-pkgconf

# Two patches touching configure.in
SDL2_TTF_AUTORECONF = YES

SDL2_TTF_CONF_ENV = \
	FREETYPE_CONFIG=$(STAGING_DIR)/usr/bin/freetype-config

# x-includes and x-libraries must be set for cross-compiling
# By default x_includes and x_libraries contains unsafe paths.
# (/usr/include and /usr/lib)
ifeq ($(BR2_PACKAGE_SDL2_X11),y)
SDL2_TTF_CONF_OPTS += \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib
else
SDL2_TTF_CONF_OPTS += \
	--without-x
endif

$(eval $(autotools-package))
