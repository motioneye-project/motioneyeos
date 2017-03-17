################################################################################
#
# sdl2_gfx
#
################################################################################

SDL2_GFX_VERSION = 1.0.1
SDL2_GFX_SOURCE = SDL2_gfx-$(SDL2_GFX_VERSION).tar.gz
SDL2_GFX_SITE = http://www.ferzkopp.net/Software/SDL2_gfx
SDL2_GFX_LICENSE = zlib
SDL2_GFX_LICENSE_FILES = COPYING SDL2_framerate.h
SDL2_GFX_INSTALL_STAGING = YES
SDL2_GFX_DEPENDENCIES = sdl2 host-pkgconf
SDL2_GFX_CONF_OPTS = --disable-sdltest
# configure/Makefile.in not up-to-date, causing aclocal to be used at
# build time if we don't autoreconf.
SDL2_GFX_AUTORECONF = YES

# Even though x86_64 processors support MMX, the MMX-specific assembly
# code in sdl2_gfx is IA32 specific, and does not build for x86_64.
ifeq ($(BR2_i386)$(BR2_X86_CPU_HAS_MMX),yy)
SDL2_GFX_CONF_OPTS += --enable-mmx
else
SDL2_GFX_CONF_OPTS += --disable-mmx
endif

$(eval $(autotools-package))
