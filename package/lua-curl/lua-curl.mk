################################################################################
#
# lua-curl
#
################################################################################

LUA_CURL_VERSION_UPSTREAM = 0.3.7
LUA_CURL_VERSION = $(LUA_CURL_VERSION_UPSTREAM)-1
LUA_CURL_SUBDIR = Lua-cURLv3-$(LUA_CURL_VERSION_UPSTREAM)
LUA_CURL_LICENSE = MIT
LUA_CURL_LICENSE_FILES = $(LUA_CURL_SUBDIR)/LICENSE
LUA_CURL_DEPENDENCIES = libcurl

$(eval $(luarocks-package))
