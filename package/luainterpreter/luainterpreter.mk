################################################################################
#
# luainterpreter
#
################################################################################

LUAINTERPRETER_ABIVER = $(call qstrip,$(BR2_PACKAGE_LUAINTERPRETER_ABI_VERSION))

# Lua packages often install documentation, clean that up globally
# Since luainterpreter is a virtual package, we can't use
# LUAINTERPRETER_TARGET_FINALIZE_HOOKS
ifeq ($(BR2_PACKAGE_HAS_LUAINTERPRETER),y)
define LUAINTERPRETER_REMOVE_DOC
	rm -rf $(TARGET_DIR)/usr/share/lua/$(LUAINTERPRETER_ABIVER)/doc
endef

TARGET_FINALIZE_HOOKS += LUAINTERPRETER_REMOVE_DOC
endif

$(eval $(virtual-package))
$(eval $(host-virtual-package))

LUA_RUN = $(HOST_DIR)/bin/$(call qstrip,$(BR2_PACKAGE_PROVIDES_LUAINTERPRETER))
