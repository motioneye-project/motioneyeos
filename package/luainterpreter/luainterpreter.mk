################################################################################
#
# luainterpreter
#
################################################################################

LUAINTERPRETER_SOURCE =
LUAINTERPRETER_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_LUA_INTERPRETER))

LUAINTERPRETER_ABIVER = $(call qstrip,$(BR2_PACKAGE_LUAINTERPRETER_ABI_VERSION))

ifeq ($(BR2_PACKAGE_HAS_LUA_INTERPRETER),y)
ifeq ($(LUAINTERPRETER_DEPENDENCIES),)
$(error No lua interpreter implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
