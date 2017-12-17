################################################################################
#
# lua-basexx
#
################################################################################

LUA_BASEXX_VERSION_UPSTREAM =0.4.0
LUA_BASEXX_VERSION = $(LUA_BASEXX_VERSION_UPSTREAM)-1
LUA_BASEXX_NAME_UPSTREAM = basexx
LUA_BASEXX_SUBDIR = basexx-$(LUA_BASEXX_VERSION_UPSTREAM)
LUA_BASEXX_LICENSE = MIT
LUA_BASEXX_LICENSE_FILES = $(LUA_BASEXX_SUBDIR)/LICENSE

$(eval $(luarocks-package))
