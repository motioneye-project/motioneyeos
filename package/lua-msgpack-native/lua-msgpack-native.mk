################################################################################
#
# lua-msgpack-native
#
################################################################################

LUA_MSGPACK_NATIVE_VERSION = 41a91b994c70389dc9daa1a15678741d8ec41749
LUA_MSGPACK_NATIVE_SITE = $(call github,kengonakajima,lua-msgpack-native,$(LUA_MSGPACK_NATIVE_VERSION))
LUA_MSGPACK_NATIVE_DEPENDENCIES = luainterpreter
LUA_MSGPACK_NATIVE_LICENSE = Apache-2.0
LUA_MSGPACK_NATIVE_LICENSE_FILES = LICENSE.txt

# lua-msgpack-native uses the old Lua 5.0 API with luaL_reg, but it is
# no longer provided by LuaJit 2.1, so we have to alias luaL_reg to
# luaL_Reg.
define LUA_MSGPACK_NATIVE_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) -DluaL_reg=luaL_Reg -fPIC \
		-shared -o $(@D)/msgpack.so $(@D)/mp.c
endef

define LUA_MSGPACK_NATIVE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/msgpack.so \
		$(TARGET_DIR)/usr/lib/lua/$(LUAINTERPRETER_ABIVER)/msgpack.so
endef

$(eval $(generic-package))
