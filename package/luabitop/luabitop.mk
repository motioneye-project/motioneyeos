################################################################################
#
# luabitop
#
################################################################################

LUABITOP_VERSION = 1.0.2
LUABITOP_SOURCE = LuaBitOp-$(LUABITOP_VERSION).tar.gz
LUABITOP_SITE = http://bitop.luajit.org/download
LUABITOP_LICENSE = MIT
LUABITOP_LICENSE_FILES = README
LUABITOP_DEPENDENCIES = lua

define LUABITOP_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define LUABITOP_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/lua
	$(INSTALL) -p $(@D)/bit.so $(TARGET_DIR)/usr/lib/lua
endef

define LUABITOP_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
