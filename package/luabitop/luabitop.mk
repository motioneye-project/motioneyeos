################################################################################
#
# luabitop
#
################################################################################

LUABITOP_VERSION_UPSTREAM = 1.0.2
LUABITOP_VERSION = $(LUABITOP_VERSION_UPSTREAM)-1
LUABITOP_SUBDIR  = LuaBitOp-$(LUABITOP_VERSION_UPSTREAM)
LUABITOP_LICENSE = MIT
LUABITOP_LICENSE_FILES = $(LUABITOP_SUBDIR)/README

$(eval $(luarocks-package))
