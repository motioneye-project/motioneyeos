################################################################################
#
# lua-http
#
################################################################################

LUA_HTTP_VERSION_UPSTREAM = 0.3
LUA_HTTP_VERSION = $(LUA_HTTP_VERSION_UPSTREAM)-0
LUA_HTTP_NAME_UPSTREAM = http
LUA_HTTP_SUBDIR = lua-http-$(LUA_HTTP_VERSION_UPSTREAM)
LUA_HTTP_LICENSE = MIT
LUA_HTTP_LICENSE_FILES = $(LUA_HTTP_SUBDIR)/LICENSE.md

$(eval $(luarocks-package))
