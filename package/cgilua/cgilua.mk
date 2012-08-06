#############################################################
#
# cgilua
#
#############################################################

CGILUA_VERSION = 5.1.4
CGILUA_SITE = http://github.com/downloads/keplerproject/cgilua
CGILUA_DEPENDENCIES = luafilesystem
CGILUA_LICENSE = MIT

define CGILUA_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install LUA_DIR="$(TARGET_DIR)/usr/share/lua"
endef

define CGILUA_UNINSTALL_TARGET_CMDS
	rm -rf "$(TARGET_DIR)/usr/share/lua/cgilua"
	rm -f "$(TARGET_DIR)/usr/share/lua/cgilua.lua"
endef

$(eval $(generic-package))
