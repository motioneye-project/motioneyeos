################################################################################
#
# lua-messagepack
#
################################################################################

LUA_MESSAGEPACK_VERSION_UPSTREAM = 0.3.4
ifeq ($(BR2_PACKAGE_LUA_5_3),y)
LUA_MESSAGEPACK_VERSION = lua53-$(LUA_MESSAGEPACK_VERSION_UPSTREAM)-1
else
LUA_MESSAGEPACK_VERSION = $(LUA_MESSAGEPACK_VERSION_UPSTREAM)-1
endif
LUA_MESSAGEPACK_SUBDIR = lua-MessagePack-$(LUA_MESSAGEPACK_VERSION_UPSTREAM)
LUA_MESSAGEPACK_LICENSE = MIT
LUA_MESSAGEPACK_LICENSE_FILES = $(LUA_MESSAGEPACK_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
