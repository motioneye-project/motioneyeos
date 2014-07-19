################################################################################
#
# luainterpreter
#
################################################################################

LUAINTERPRETER_ABIVER = $(call qstrip,$(BR2_PACKAGE_LUAINTERPRETER_ABI_VERSION))

$(eval $(virtual-package))
$(eval $(host-virtual-package))
