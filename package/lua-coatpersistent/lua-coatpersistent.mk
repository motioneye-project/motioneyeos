################################################################################
#
# lua-coatpersistent
#
################################################################################

LUA_COATPERSISTENT_VERSION_UPSTREAM = 0.2.0
LUA_COATPERSISTENT_VERSION = $(LUA_COATPERSISTENT_VERSION_UPSTREAM)-1
LUA_COATPERSISTENT_SUBDIR  = lua-CoatPersistent-$(LUA_COATPERSISTENT_VERSION_UPSTREAM)
LUA_COATPERSISTENT_LICENSE = MIT
LUA_COATPERSISTENT_LICENSE_FILES = $(LUA_COATPERSISTENT_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
