################################################################################
#
# lua-resty-http
#
################################################################################

LUA_RESTY_HTTP_VERSION = 0.15-0
LUA_RESTY_HTTP_SUBDIR = lua-resty-http
LUA_RESTY_HTTP_LICENSE = BSD-2-Clause
LUA_RESTY_HTTP_LICENSE_FILES = $(LUA_RESTY_HTTP_SUBDIR)/LICENSE

$(eval $(luarocks-package))
