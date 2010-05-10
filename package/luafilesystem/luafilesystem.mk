#############################################################
#
# luafilesystem
#
#############################################################

LUAFILESYSTEM_VERSION = 1.5.0
LUAFILESYSTEM_SITE = http://github.com/downloads/keplerproject/luafilesystem
LUAFILESYSTEM_DEPENDENCIES = lua

define LUAFILESYSTEM_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS) -fPIC"
endef

define LUAFILESYSTEM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/lfs.so $(TARGET_DIR)/usr/lib/lua/lfs.so
endef

define LUAFILESYSTEM_UNINSTALL_TARGET_CMDS
	rm -f "$(TARGET_DIR)/usr/lib/lua/lfs.so"
endef

define LUAFILESYSTEM_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS,package,luafilesystem))
