################################################################################
#
# lua-cqueues
#
################################################################################

LUA_CQUEUES_VERSION = rel-20161215
LUA_CQUEUES_SITE = $(call github,wahern,cqueues,$(LUA_CQUEUES_VERSION))
LUA_CQUEUES_LICENSE = MIT
LUA_CQUEUES_LICENSE_FILES = LICENSE
LUA_CQUEUES_DEPENDENCIES = luainterpreter openssl host-m4

define LUA_CQUEUES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		prefix="$(STAGING_DIR)/usr" all$(LUAINTERPRETER_ABIVER)
endef

define LUA_CQUEUES_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" prefix=/usr install$(LUAINTERPRETER_ABIVER)
endef

$(eval $(generic-package))
