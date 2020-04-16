################################################################################
#
# lua-lyaml
#
################################################################################

LUA_LYAML_VERSION = 6.2.5
LUA_LYAML_NAME_UPSTREAM = lyaml
LUA_LYAML_SITE = $(call github,gvvaughan,$(LUA_LYAML_NAME_UPSTREAM),v$(LUA_LYAML_VERSION))
LUA_LYAML_LICENSE = MIT
LUA_LYAML_LICENSE_FILES = LICENSE
LUA_LYAML_DEPENDENCIES = libyaml luainterpreter host-lua

define LUA_LYAML_BUILD_CMDS
	(cd $(@D); \
		$(LUA_RUN) build-aux/luke \
		version="'$(LUA_LYAML_VERSION)'" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LUA_INCDIR=$(STAGING_DIR)/usr/include \
		YAML_DIR=$(STAGING_DIR)/usr \
	)
endef

define LUA_LYAML_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(LUA_RUN) build-aux/luke install \
		INST_LIBDIR="$(TARGET_DIR)/usr/lib/lua/$(LUAINTERPRETER_ABIVER)" \
		INST_LUADIR="$(TARGET_DIR)/usr/share/lua/$(LUAINTERPRETER_ABIVER)" \
	)
endef

$(eval $(generic-package))
