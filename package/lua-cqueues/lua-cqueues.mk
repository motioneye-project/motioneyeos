################################################################################
#
# lua-cqueues
#
################################################################################

LUA_CQUEUES_VERSION = 20190813
LUA_CQUEUES_SITE = $(call github,wahern,cqueues,rel-$(LUA_CQUEUES_VERSION))
LUA_CQUEUES_LICENSE = MIT
LUA_CQUEUES_LICENSE_FILES = LICENSE
LUA_CQUEUES_DEPENDENCIES = luainterpreter openssl host-m4

LUA_CQUEUES_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
LUA_CQUEUES_CFLAGS += -O0
endif

define LUA_CQUEUES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(LUA_CQUEUES_CFLAGS)" -C $(@D) \
		prefix="$(STAGING_DIR)/usr" all$(LUAINTERPRETER_ABIVER)
endef

define LUA_CQUEUES_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" prefix=/usr install$(LUAINTERPRETER_ABIVER)
endef

$(eval $(generic-package))
