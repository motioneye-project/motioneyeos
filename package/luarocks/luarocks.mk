################################################################################
#
# luarocks
#
################################################################################

LUAROCKS_VERSION = 3.3.1
LUAROCKS_SITE = http://luarocks.org/releases
LUAROCKS_LICENSE = MIT
LUAROCKS_LICENSE_FILES = COPYING

HOST_LUAROCKS_DEPENDENCIES = host-luainterpreter

LUAROCKS_CONFIG_DIR = $(HOST_DIR)/etc
LUAROCKS_CONFIG_FILE = $(LUAROCKS_CONFIG_DIR)/luarocks/config-$(LUAINTERPRETER_ABIVER).lua
LUAROCKS_CFLAGS = $(TARGET_CFLAGS) -fPIC
ifeq ($(BR2_PACKAGE_LUA_5_3),y)
LUAROCKS_CFLAGS += -DLUA_COMPAT_5_2
endif

define LUAROCKS_ADDON_EXTRACT
	mkdir $(@D)/src/luarocks/cmd/external
	cp package/luarocks/buildroot.lua $(@D)/src/luarocks/cmd/external/buildroot.lua
endef
HOST_LUAROCKS_POST_EXTRACT_HOOKS += LUAROCKS_ADDON_EXTRACT

HOST_LUAROCKS_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--sysconfdir=$(LUAROCKS_CONFIG_DIR) \
	--with-lua=$(HOST_DIR)

define HOST_LUAROCKS_CONFIGURE_CMDS
	cd $(@D) && ./configure $(HOST_LUAROCKS_CONF_OPTS)
endef

ifeq ($(BR2_PACKAGE_LUAJIT),y)
define LUAROCKS_CONFIGURE_INTERPRETER_LUAJIT
	echo "lua_interpreter = [[luajit]]" >> $(LUAROCKS_CONFIG_FILE)
endef
endif

define HOST_LUAROCKS_INSTALL_CMDS
	rm -f $(LUAROCKS_CONFIG_FILE)
	$(MAKE1) -C $(@D) install
	cat $(HOST_LUAROCKS_PKGDIR)/luarocks-br-config.lua >> $(LUAROCKS_CONFIG_FILE)
	$(LUAROCKS_CONFIGURE_INTERPRETER_LUAJIT)
endef

$(eval $(host-generic-package))

LUAROCKS_RUN_ENV = \
	LUA_PATH="$(HOST_DIR)/share/lua/$(LUAINTERPRETER_ABIVER)/?.lua" \
	TARGET_CC="$(TARGET_CC)" \
	TARGET_CFLAGS="$(LUAROCKS_CFLAGS)" \
	TARGET_LDFLAGS="$(TARGET_LDFLAGS)"
LUAROCKS_RUN_CMD = $(LUA_RUN) $(HOST_DIR)/bin/luarocks

define LUAROCKS_FINALIZE_TARGET
	rm -rf $(TARGET_DIR)/usr/lib/luarocks
endef

# Apply to global variable directly, as pkg-generic does not
ifneq ($(BR2_PACKAGE_LUAJIT)$(BR2_PACKAGE_LUA),)
TARGET_FINALIZE_HOOKS += LUAROCKS_FINALIZE_TARGET
endif
