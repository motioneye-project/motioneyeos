################################################################################
#
# luarocks
#
################################################################################

LUAROCKS_VERSION = 3.0.4
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

HOST_LUAROCKS_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--sysconfdir=$(LUAROCKS_CONFIG_DIR) \
	--with-lua=$(HOST_DIR)

define HOST_LUAROCKS_CONFIGURE_CMDS
	cd $(@D) && ./configure $(HOST_LUAROCKS_CONF_OPTS)
endef

define HOST_LUAROCKS_INSTALL_CMDS
	rm -f $(LUAROCKS_CONFIG_FILE)
	$(MAKE1) -C $(@D) install
	echo "-- BR cross-compilation"                                  >> $(LUAROCKS_CONFIG_FILE)
	echo "variables.LUA_INCDIR = [[$(STAGING_DIR)/usr/include]]"    >> $(LUAROCKS_CONFIG_FILE)
	echo "variables.LUA_LIBDIR = [[$(STAGING_DIR)/usr/lib]]"        >> $(LUAROCKS_CONFIG_FILE)
	echo "variables.CC = [[$(TARGET_CC)]]"                          >> $(LUAROCKS_CONFIG_FILE)
	echo "variables.LD = [[$(TARGET_CC)]]"                          >> $(LUAROCKS_CONFIG_FILE)
	echo "variables.CFLAGS = [[$(LUAROCKS_CFLAGS)]]"                >> $(LUAROCKS_CONFIG_FILE)
	echo "variables.LIBFLAG = [[-shared $(TARGET_LDFLAGS)]]"        >> $(LUAROCKS_CONFIG_FILE)
	echo "external_deps_dirs = { [[$(STAGING_DIR)/usr]] }"          >> $(LUAROCKS_CONFIG_FILE)
	echo "gcc_rpath = false"                                        >> $(LUAROCKS_CONFIG_FILE)
	echo "rocks_trees = { [[$(TARGET_DIR)/usr]] }"                  >> $(LUAROCKS_CONFIG_FILE)
	echo "wrap_bin_scripts = false"                                 >> $(LUAROCKS_CONFIG_FILE)
	echo "deps_mode = [[none]]"                                     >> $(LUAROCKS_CONFIG_FILE)
endef

$(eval $(host-generic-package))

LUAROCKS_RUN_ENV = LUA_PATH="$(HOST_DIR)/share/lua/$(LUAINTERPRETER_ABIVER)/?.lua"
LUAROCKS_RUN_CMD = $(LUA_RUN) $(HOST_DIR)/bin/luarocks

define LUAROCKS_FINALIZE_TARGET
	rm -rf $(TARGET_DIR)/usr/lib/luarocks
endef

# Apply to global variable directly, as pkg-generic does not
ifneq ($(BR2_PACKAGE_LUAJIT)$(BR2_PACKAGE_LUA),)
TARGET_FINALIZE_HOOKS += LUAROCKS_FINALIZE_TARGET
endif
