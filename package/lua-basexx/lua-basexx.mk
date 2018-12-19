################################################################################
#
# lua-basexx
#
################################################################################

LUA_BASEXX_VERSION = 0.4.0-1
LUA_BASEXX_NAME_UPSTREAM = basexx
LUA_BASEXX_LICENSE = MIT
LUA_BASEXX_LICENSE_FILES = $(LUA_BASEXX_SUBDIR)/LICENSE

$(eval $(luarocks-package))
