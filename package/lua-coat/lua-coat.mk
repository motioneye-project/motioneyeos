################################################################################
#
# lua-coat
#
################################################################################

LUA_COAT_VERSION = 0.9.1-1
LUA_COAT_NAME_UPSTREAM = lua-Coat
LUA_COAT_LICENSE = MIT
LUA_COAT_LICENSE_FILES = $(LUA_COAT_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
