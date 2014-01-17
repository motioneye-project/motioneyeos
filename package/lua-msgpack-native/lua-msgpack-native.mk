################################################################################
#
# lua-msgpack-native
#
################################################################################

LUA_MSGPACK_NATIVE_VERSION = 41cce91ab6b54e4426c6d626a0ac41a02ec2096d
LUA_MSGPACK_NATIVE_SITE = $(call github,kengonakajima,lua-msgpack-native,$(LUA_MSGPACK_NATIVE_VERSION))
LUA_MSGPACK_NATIVE_DEPENDENCIES = luainterpreter
LUA_MSGPACK_NATIVE_LICENSE = Apache-2.0
LUA_MSGPACK_NATIVE_LICENSE_FILES = LICENSE.txt

define LUA_MSGPACK_NATIVE_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) -fPIC -shared -o $(@D)/msgpack.so $(@D)/mp.c
endef

define LUA_MSGPACK_NATIVE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/msgpack.so \
		$(TARGET_DIR)/usr/lib/lua/$(LUAINTERPRETER_ABIVER)/msgpack.so
endef

$(eval $(generic-package))
