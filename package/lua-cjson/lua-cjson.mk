################################################################################
#
# lua-cjson
#
################################################################################

LUA_CJSON_VERSION = 2.1.0.6-1
LUA_CJSON_SUBDIR = lua-cjson
LUA_CJSON_LICENSE = MIT
LUA_CJSON_LICENSE_FILES = $(LUA_CJSON_SUBDIR)/LICENSE

$(eval $(luarocks-package))
