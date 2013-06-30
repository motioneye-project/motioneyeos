################################################################################
#
# lua
#
################################################################################

LUA_VERSION = 5.1.5
LUA_SITE = http://www.lua.org/ftp
LUA_INSTALL_STAGING = YES
LUA_LICENSE = MIT
LUA_LICENSE_FILES = COPYRIGHT

LUA_CFLAGS = -Wall -fPIC
LUA_MYLIBS += -ldl

ifeq ($(BR2_PACKAGE_LUA_INTERPRETER_READLINE),y)
	LUA_DEPENDENCIES = readline ncurses
	LUA_MYLIBS += -lreadline -lhistory -lncurses
	LUA_CFLAGS += -DLUA_USE_POSIX -DLUA_USE_DLOPEN -DLUA_USE_READLINE
else
ifeq ($(BR2_PACKAGE_LUA_INTERPRETER_LINENOISE),y)
	LUA_DEPENDENCIES = linenoise
	LUA_MYLIBS += -llinenoise
	LUA_CFLAGS += -DLUA_USE_POSIX -DLUA_USE_DLOPEN -DLUA_USE_LINENOISE
else
	LUA_CFLAGS += -DLUA_USE_POSIX -DLUA_USE_DLOPEN
endif
endif

# We never want to have host-readline and host-ncurses as dependencies
# of host-lua.
HOST_LUA_DEPENDENCIES =
HOST_LUA_CFLAGS = -Wall -fPIC -DLUA_USE_DLOPEN -DLUA_USE_POSIX
HOST_LUA_MYLIBS = -ldl

define LUA_BUILD_CMDS
	$(MAKE) \
	CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" \
	CFLAGS="$(TARGET_CFLAGS) $(LUA_CFLAGS)" \
	MYLIBS="$(LUA_MYLIBS)" AR="$(TARGET_CROSS)ar rcu" \
	PKG_VERSION=$(LUA_VERSION) -C $(@D)/src all
endef

define HOST_LUA_BUILD_CMDS
	$(MAKE) \
	CFLAGS="$(HOST_LUA_CFLAGS)" \
	MYLDFLAGS="$(HOST_LDFLAGS)" \
	MYLIBS="$(HOST_LUA_MYLIBS)" \
	PKG_VERSION=$(LUA_VERSION) -C $(@D)/src all
endef

define LUA_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/etc/lua.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/lua.pc
	$(INSTALL) -m 0755 -D $(@D)/src/lua $(STAGING_DIR)/usr/bin/lua
	$(INSTALL) -m 0755 -D $(@D)/src/luac $(STAGING_DIR)/usr/bin/luac
	$(INSTALL) -m 0755 -D $(@D)/src/liblua.so.$(LUA_VERSION) \
		$(STAGING_DIR)/usr/lib/liblua.so.$(LUA_VERSION)
	ln -sf liblua.so.$(LUA_VERSION) $(STAGING_DIR)/usr/lib/liblua.so
	$(INSTALL) -m 0644 -D $(@D)/src/liblua.a $(STAGING_DIR)/usr/lib/liblua.a
	$(INSTALL) -m 0644 -D $(@D)/src/lua.h $(STAGING_DIR)/usr/include/lua.h
	$(INSTALL) -m 0644 -D $(@D)/src/luaconf.h $(STAGING_DIR)/usr/include/luaconf.h
	$(INSTALL) -m 0644 -D $(@D)/src/lualib.h $(STAGING_DIR)/usr/include/lualib.h
	$(INSTALL) -m 0644 -D $(@D)/src/lauxlib.h $(STAGING_DIR)/usr/include/lauxlib.h
endef

define LUA_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/src/lua $(TARGET_DIR)/usr/bin/lua
	$(INSTALL) -m 0755 -D $(@D)/src/luac $(TARGET_DIR)/usr/bin/luac
	$(INSTALL) -m 0755 -D $(@D)/src/liblua.so.$(LUA_VERSION) \
		$(TARGET_DIR)/usr/lib/liblua.so.$(LUA_VERSION)
	ln -sf liblua.so.$(LUA_VERSION) $(TARGET_DIR)/usr/lib/liblua.so
	$(INSTALL) -m 0644 -D $(@D)/src/liblua.a $(TARGET_DIR)/usr/lib/liblua.a
endef

define HOST_LUA_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/src/lua $(HOST_DIR)/usr/bin/lua
	$(INSTALL) -m 0755 -D $(@D)/src/luac $(HOST_DIR)/usr/bin/luac
	$(INSTALL) -m 0755 -D $(@D)/src/liblua.so.$(LUA_VERSION) \
		$(HOST_DIR)/usr/lib/liblua.so.$(LUA_VERSION)
	ln -sf liblua.so.$(LUA_VERSION) $(HOST_DIR)/usr/lib/liblua.so
	$(INSTALL) -m 0644 -D $(@D)/src/liblua.a $(HOST_DIR)/usr/lib/liblua.a
	$(INSTALL) -m 0644 -D $(@D)/etc/lua.pc \
		$(HOST_DIR)/usr/lib/pkgconfig/lua.pc
	$(INSTALL) -m 0644 -D $(@D)/src/lua.h $(HOST_DIR)/usr/include/lua.h
	$(INSTALL) -m 0644 -D $(@D)/src/luaconf.h $(HOST_DIR)/usr/include/luaconf.h
	$(INSTALL) -m 0644 -D $(@D)/src/lualib.h $(HOST_DIR)/usr/include/lualib.h
	$(INSTALL) -m 0644 -D $(@D)/src/lauxlib.h $(HOST_DIR)/usr/include/lauxlib.h
endef

LUA_INSTALLED_FILES = \
	/usr/include/lua.h \
	/usr/include/luaconf.h \
	/usr/include/lualib.h \
	/usr/include/lauxlib.h \
	/usr/lib/pkgconfig/lua.pc \
	/usr/bin/lua \
	/usr/bin/luac \
	/usr/lib/liblua.a \
	/usr/lib/liblua.so*

define LUA_UNINSTALL_STAGING_CMDS
	for i in $(LUA_INSTALLED_FILES); do \
		rm -f $(STAGING_DIR)$$i; \
	done
endef

define LUA_UNINSTALL_TARGET_CMDS
	for i in $(LUA_INSTALLED_FILES); do \
		rm -f $(TARGET_DIR)$$i; \
	done
endef

define HOST_LUA_UNINSTALL_TARGET_CMDS
	for i in $(LUA_INSTALLED_FILES); do \
		rm -f $(HOST_DIR)$$i; \
	done
endef

define LUA_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

define HOST_LUA_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
