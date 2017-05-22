################################################################################
#
# lua-sdl2
#
################################################################################

LUA_SDL2_VERSION = 2.0.5.6.0-1
LUA_SDL2_LICENSE = ISC
LUA_SDL2_SUBDIR = luasdl2-2.0.5-6.0
LUA_SDL2_LICENSE_FILES = $(LUA_SDL2_SUBDIR)/LICENSE
LUA_SDL2_DEPENDENCIES = sdl2 sdl2_image sdl2_mixer sdl2_net sdl2_ttf

$(eval $(luarocks-package))
