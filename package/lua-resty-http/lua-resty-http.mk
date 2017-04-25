################################################################################
#
# lua-resty-http
#
################################################################################

LUA_RESTY_HTTP_VERSION = 0.10-0
LUA_RESTY_HTTP_SUBDIR = lua-resty-http
LUA_RESTY_HTTP_LICENSE = BSD-2-Clause
LUA_RESTY_HTTP_LICENSE_FILES = LICENSE

$(eval $(luarocks-package))
