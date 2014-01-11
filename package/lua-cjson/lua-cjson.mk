################################################################################
#
# lua-cjson
#
################################################################################

LUA_CJSON_VERSION_UPSTREAM = 2.1.0
LUA_CJSON_VERSION = $(LUA_CJSON_VERSION_UPSTREAM)-1
LUA_CJSON_LICENSE = MIT
LUA_CJSON_LICENSE_FILES = lua-cjson-$(LUA_CJSON_VERSION_UPSTREAM)/LICENSE

$(eval $(luarocks-package))
