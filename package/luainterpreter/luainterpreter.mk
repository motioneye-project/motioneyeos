################################################################################
#
# luainterpreter
#
################################################################################

LUAINTERPRETER_ABIVER = $(call qstrip,$(BR2_PACKAGE_LUAINTERPRETER_ABI_VERSION))

$(eval $(virtual-package))
$(eval $(host-virtual-package))

LUA_RUN = $(HOST_DIR)/usr/bin/$(call qstrip,$(BR2_PACKAGE_PROVIDES_LUAINTERPRETER))
