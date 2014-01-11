################################################################################
#
# luaexpatutils
#
################################################################################

LUAEXPATUTILS_VERSION = 88c228365b084224c911d34aff06002634b38b50
LUAEXPATUTILS_SITE = $(call github,stevedonovan,LuaExpatUtils,$(LUAEXPATUTILS_VERSION))
LUAEXPATUTILS_LICENSE = Public Domain
LUAEXPATUTILS_DEPENDENCIES = luaexpat

define LUAEXPATUTILS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/lua/doc.lua \
		$(TARGET_DIR)/usr/share/lua/5.1/lxp/doc.lua
endef

$(eval $(generic-package))
