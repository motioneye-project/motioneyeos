################################################################################
#
# lua-std-debug
#
################################################################################

LUA_STD_DEBUG_VERSION_UPSTREAM = 1.0.1
LUA_STD_DEBUG_VERSION = $(LUA_STD_DEBUG_VERSION_UPSTREAM)-1
LUA_STD_DEBUG_NAME_UPSTREAM = std._debug
LUA_STD_DEBUG_SUBDIR = _debug-$(LUA_STD_DEBUG_VERSION_UPSTREAM)
LUA_STD_DEBUG_ROCKSPEC = $(LUA_STD_DEBUG_NAME_UPSTREAM)-$(LUA_STD_DEBUG_VERSION).rockspec
LUA_STD_DEBUG_SOURCE = $(LUA_STD_DEBUG_NAME_UPSTREAM)-$(LUA_STD_DEBUG_VERSION).src.rock
LUA_STD_DEBUG_LICENSE = MIT
LUA_STD_DEBUG_LICENSE_FILES = $(LUA_STD_DEBUG_SUBDIR)/LICENSE.md

$(eval $(luarocks-package))
