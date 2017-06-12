################################################################################
#
# lua-sdl2
#
################################################################################

LUA_SDL2_VERSION = v2.0.5-6.0
LUA_SDL2_SITE = $(call github,Tangent128,luasdl2,$(LUA_SDL2_VERSION))
LUA_SDL2_LICENSE = ISC
LUA_SDL2_LICENSE_FILES = LICENSE
LUA_SDL2_DEPENDENCIES = luainterpreter sdl2

LUA_SDL2_CONF_OPTS += -DWITH_LUAVER=user -DLUA_INCLUDE_DIR=$(STAGING_DIR)/usr/include

ifeq ($(BR2_PACKAGE_SDL2_IMAGE),y)
LUA_SDL2_DEPENDENCIES += sdl2_image
else
LUA_SDL2_CONF_OPTS += -DWITH_IMAGE=Off
endif

ifeq ($(BR2_PACKAGE_SDL2_MIXER),y)
LUA_SDL2_DEPENDENCIES += sdl2_mixer
else
LUA_SDL2_CONF_OPTS += -DWITH_MIXER=Off
endif

ifeq ($(BR2_PACKAGE_SDL2_NET),y)
LUA_SDL2_DEPENDENCIES += sdl2_net
else
LUA_SDL2_CONF_OPTS += -DWITH_NET=Off
endif

ifeq ($(BR2_PACKAGE_SDL2_TTF),y)
LUA_SDL2_DEPENDENCIES += sdl2_ttf
else
LUA_SDL2_CONF_OPTS += -DWITH_TTF=Off
endif

$(eval $(cmake-package))
