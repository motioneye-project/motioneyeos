################################################################################
#
# luabitop
#
################################################################################

LUABITOP_VERSION = 1.0.2-1
LUABITOP_NAME_UPSTREAM = LuaBitOp
LUABITOP_LICENSE = MIT
LUABITOP_LICENSE_FILES = $(LUABITOP_SUBDIR)/README

$(eval $(luarocks-package))
