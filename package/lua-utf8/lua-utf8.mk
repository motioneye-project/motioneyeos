################################################################################
#
# lua-utf8
#
################################################################################

LUA_UTF8_VERSION = 0.1.2-2
LUA_UTF8_NAME_UPSTREAM = luautf8
LUA_UTF8_LICENSE = MIT
LUA_UTF8_LICENSE_FILES = $(LUA_UTF8_SUBDIR)/LICENSE

$(eval $(luarocks-package))
