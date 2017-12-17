################################################################################
#
# sdl_gfx
#
################################################################################

SDL_GFX_VERSION_MAJOR = 2.0
SDL_GFX_VERSION = $(SDL_GFX_VERSION_MAJOR).23
SDL_GFX_SOURCE = SDL_gfx-$(SDL_GFX_VERSION).tar.gz
SDL_GFX_SITE = http://www.ferzkopp.net/Software/SDL_gfx-$(SDL_GFX_VERSION_MAJOR)
SDL_GFX_LICENSE = Zlib
SDL_GFX_LICENSE_FILES = COPYING LICENSE
SDL_GFX_INSTALL_STAGING = YES
SDL_GFX_DEPENDENCIES = sdl
SDL_GFX_CONF_OPTS = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--disable-sdltest \
	--enable-static

# Even though x86_64 processors support MMX, the MMX-specific assembly
# code in sdl_gfx is IA32 specific, and does not build for x86_64.
ifeq ($(BR2_i386)$(BR2_X86_CPU_HAS_MMX),yy)
SDL_GFX_CONF_OPTS += --enable-mmx
else
SDL_GFX_CONF_OPTS += --disable-mmx
endif

$(eval $(autotools-package))
