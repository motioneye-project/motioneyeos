################################################################################
#
# lua-coat
#
################################################################################

LUA_COAT_VERSION_UPSTREAM = 0.9.1
LUA_COAT_VERSION = $(LUA_COAT_VERSION_UPSTREAM)-1
LUA_COAT_SUBDIR = lua-Coat-$(LUA_COAT_VERSION_UPSTREAM)
LUA_COAT_LICENSE = MIT
LUA_COAT_LICENSE_FILES = $(LUA_COAT_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
