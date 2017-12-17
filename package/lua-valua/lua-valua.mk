################################################################################
#
# lua-valua
#
################################################################################

LUA_VALUA_VERSION = 0.3-1
LUA_VALUA_NAME_UPSTREAM = valua
LUA_VALUA_SUBDIR = valua
LUA_VALUA_LICENSE = MIT
LUA_VALUA_LICENSE_FILES = $(LUA_VALUA_SUBDIR)/LICENSE

$(eval $(luarocks-package))
