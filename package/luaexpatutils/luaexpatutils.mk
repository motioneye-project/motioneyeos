################################################################################
#
# luaexpatutils
#
################################################################################

LUAEXPATUTILS_VERSION = 88c228365b
LUAEXPATUTILS_SITE = http://github.com/stevedonovan/LuaExpatUtils/tarball/$(LUAEXPATUTILS_VERSION)
LUAEXPATUTILS_LICENSE = Public Domain
LUAEXPATUTILS_DEPENDENCIES = luaexpat

define LUAEXPATUTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/lua/doc.lua \
		$(TARGET_DIR)/usr/share/lua/lxp/doc.lua
endef

define LUAEXPATUTILS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/share/lua/lxp/doc.lua
endef

$(eval $(generic-package))
