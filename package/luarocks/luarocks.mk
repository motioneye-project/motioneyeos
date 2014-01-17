################################################################################
#
# luarocks
#
################################################################################

LUAROCKS_VERSION = 2.1.2
LUAROCKS_SITE = http://luarocks.org/releases/
LUAROCKS_LICENSE = MIT
LUAROCKS_LICENSE_FILES = COPYING

HOST_LUAROCKS_DEPENDENCIES = host-lua luainterpreter

LUAROCKS_CONFIG_DIR  = $(HOST_DIR)/usr/etc/luarocks
LUAROCKS_CONFIG_FILE = $(LUAROCKS_CONFIG_DIR)/config-$(LUAINTERPRETER_ABIVER).lua

define HOST_LUAROCKS_CONFIGURE_CMDS
	cd $(@D) && ./configure \
		--prefix=$(HOST_DIR)/usr \
		--sysconfdir=$(LUAROCKS_CONFIG_DIR) \
		--with-lua=$(HOST_DIR)/usr
endef

define HOST_LUAROCKS_INSTALL_CMDS
	rm -f $(LUAROCKS_CONFIG_FILE)
	$(MAKE1) -C $(@D) install \
		PREFIX=$(HOST_DIR)/usr
	echo "-- BR cross-compilation"                          >> $(LUAROCKS_CONFIG_FILE)
	echo "variables = {"                                    >> $(LUAROCKS_CONFIG_FILE)
	echo "   LUA_INCDIR = [[$(STAGING_DIR)/usr/include]],"  >> $(LUAROCKS_CONFIG_FILE)
	echo "   LUA_LIBDIR = [[$(STAGING_DIR)/usr/lib]],"      >> $(LUAROCKS_CONFIG_FILE)
	echo "   CC = [[$(TARGET_CC)]],"                        >> $(LUAROCKS_CONFIG_FILE)
	echo "   LD = [[$(TARGET_CC)]],"                        >> $(LUAROCKS_CONFIG_FILE)
	echo "   CFLAGS = [[$(TARGET_CFLAGS) -fPIC]],"          >> $(LUAROCKS_CONFIG_FILE)
	echo "   LIBFLAG = [[-shared $(TARGET_LDFLAGS)]],"      >> $(LUAROCKS_CONFIG_FILE)
	echo "}"                                                >> $(LUAROCKS_CONFIG_FILE)
	echo "external_deps_dirs = { [[$(STAGING_DIR)/usr]] }"  >> $(LUAROCKS_CONFIG_FILE)
	echo "gcc_rpath = false"                                >> $(LUAROCKS_CONFIG_FILE)
	echo "rocks_trees = { [[$(TARGET_DIR)/usr]] }"          >> $(LUAROCKS_CONFIG_FILE)
endef

$(eval $(host-generic-package))

LUAROCKS_RUN = LUA_PATH="$(HOST_DIR)/usr/share/lua/$(LUAINTERPRETER_ABIVER)/?.lua" \
	$(HOST_DIR)/usr/bin/lua $(HOST_DIR)/usr/bin/luarocks
