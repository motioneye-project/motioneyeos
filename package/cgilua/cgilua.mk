#############################################################
#
# cgilua
#
#############################################################

CGILUA_VERSION = 5.1.3
CGILUA_SITE = http://luaforge.net/frs/download.php/3970
CGILUA_DEPENDENCIES = luafilesystem

define CGILUA_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install LUA_DIR="$(TARGET_DIR)/usr/share/lua"
endef

define CGILUA_UNINSTALL_TARGET_CMDS
	rm -rf "$(TARGET_DIR)/usr/share/lua/cgilua"
	rm -f "$(TARGET_DIR)/usr/share/lua/cgilua.lua"
endef

$(eval $(call GENTARGETS,package,cgilua))
