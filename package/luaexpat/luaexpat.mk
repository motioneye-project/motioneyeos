#############################################################
#
# luaexpat
#
#############################################################

LUAEXPAT_VERSION      = 1.2.0
LUAEXPAT_SITE         = http://matthewwild.co.uk/projects/luaexpat
LUAEXPAT_DEPENDENCIES = lua expat
LUAEXPAT_LICENSE      = MIT


LUAEXPAT_MFLAGS += LUA_VERSION_NUM=501
LUAEXPAT_MFLAGS += LUA_INC=$(STAGING_DIR)/usr/include/lua
LUAEXPAT_MFLAGS += EXPAT_INC=$(STAGING_DIR)/usr/include
LUAEXPAT_MFLAGS += LIBNAME=lxp.so
LUAEXPAT_MFLAGS += LIB_OPTION="-shared -fPIC $(TARGET_CFLAGS)"
LUAEXPAT_MFLAGS += CC="$(TARGET_CC) -fPIC $(TARGET_CFLAGS)"


define LUAEXPAT_BUILD_CMDS
	$(MAKE) -C $(@D) $(LUAEXPAT_MFLAGS)
endef

define LUAEXPAT_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/lxp.so $(TARGET_DIR)/usr/lib/lua/lxp.so
	$(INSTALL) -D -m 0644 $(@D)/src/lxp/lom.lua $(TARGET_DIR)/usr/share/lua/lxp/lom.lua
endef

define LUAEXPAT_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/lua/lxp.so
	rm -f $(TARGET_DIR)/usr/share/lua/lxp/lom.lua
endef

define LUAEXPAT_CLEAN_CMDS
	$(MAKE) -C $(@D) $(LUAEXPAT_MFLAGS) clean
endef

$(eval $(generic-package))
