################################################################################
#
# lua-bit32
#
################################################################################

LUA_BIT32_VERSION = 5.3.0-1
LUA_BIT32_SUBDIR = lua-compat-5.2
LUA_BIT32_ROCKSPEC = bit32-$(LUA_BIT32_VERSION).rockspec
LUA_BIT32_SOURCE = bit32-$(LUA_BIT32_VERSION).src.rock
LUA_BIT32_LICENSE = MIT
LUA_BIT32_LICENSE_FILES = $(LUA_BIT32_SUBDIR)/LICENSE

$(eval $(luarocks-package))
