#############################################################
#
# luainterpreter
#
#############################################################

LUAINTERPRETER_SOURCE =
LUAINTERPRETER_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_LUA_INTERPRETER))

LUAINTERPRETER_ABIVER = $(call qstrip,$(BR2_PACKAGE_LUAINTERPRETER_ABI_VERSION))

$(eval $(generic-package))
