#############################################################
#
# coxpcall
#
#############################################################

COXPCALL_VERSION = 1.13.0
COXPCALL_SITE = http://luaforge.net/frs/download.php/3406
COXPCALL_DEPENDENCIES = lua

define COXPCALL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/src/coxpcall.lua \
		$(TARGET_DIR)/usr/share/lua/coxpcall.lua
endef

define COXPCALL_UNINSTALL_TARGET_CMDS
	rm -f "$(TARGET_DIR)/usr/share/lua/coxpcall.lua"
endef

$(eval $(call GENTARGETS,package,coxpcall))
