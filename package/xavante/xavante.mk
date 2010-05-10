#############################################################
#
# xavante
#
#############################################################

XAVANTE_VERSION = 2.2.0
XAVANTE_SITE = http://github.com/downloads/keplerproject/xavante
XAVANTE_DEPENDENCIES = cgilua copas coxpcall lua luafilesystem luasocket wsapi

define XAVANTE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PREFIX=/usr \
		LUA_DIR="$(TARGET_DIR)/usr/share/lua" \
		LUA_LIBDIR="$(TARGET_DIR)/usr/lib/lua" install
endef

define XAVANTE_UNINSTALL_TARGET_CMDS
	rm -rf "$(TARGET_DIR)/usr/share/xavante"
	rm -f "$(TARGET_DIR)/usr/share/xavante.lua"
	rm -f "$(TARGET_DIR)/usr/share/sajax.lua"
endef

$(eval $(call GENTARGETS,package,xavante))
