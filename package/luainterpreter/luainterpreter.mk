#############################################################
#
# luainterpreter
#
#############################################################

LUAINTERPRETER_SOURCE =
LUAINTERPRETER_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_LUA_INTERPRETER))

$(eval $(generic-package))
