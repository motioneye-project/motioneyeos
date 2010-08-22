#############################################################
#
# lua
#
#############################################################

LUA_VERSION = 5.1.4
LUA_SITE = http://www.lua.org/ftp
LUA_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LUA_SHARED_LIBRARY),y)
	LUA_MYCFLAGS += -fPIC -DLUA_USE_DLOPEN
	LUA_MYLIBS += -ldl
endif

ifeq ($(BR2_PACKAGE_LUA_INTERPRETER_READLINE),y)
	LUA_DEPENDENCIES = readline ncurses
	LUA_MYLIBS += -lreadline -lhistory -lncurses
	LUA_MYCFLAGS += -DLUA_USE_LINUX
else
	LUA_MYCFLAGS += -DLUA_USE_POSIX
endif

define LUA_BUILD_CMDS
	sed -i -e 's/-O2//' $(@D)/src/Makefile
	sed -i -e 's/\/usr\/local/\/usr/' $(@D)/etc/lua.pc
	$(MAKE) \
	CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" \
	MYCFLAGS="$(TARGET_CFLAGS) $(LUA_MYCFLAGS)" \
	MYLIBS="$(LUA_MYLIBS)" AR="$(TARGET_CROSS)ar rcu" \
	PKG_VERSION=$(LUA_VERSION) -C $(@D)/src all
endef

ifeq ($(BR2_PACKAGE_LUA_SHARED_LIBRARY),y)
define LUA_INSTALL_STAGING_SHARED_LIB
	$(INSTALL) -D $(@D)/src/liblua.so.$(LUA_VERSION) \
		$(STAGING_DIR)/usr/lib/liblua.so.$(LUA_VERSION)
	ln -sf liblua.so.$(LUA_VERSION) $(STAGING_DIR)/usr/lib/liblua.so
endef
endif

define LUA_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0644 -D $(@D)/etc/lua.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/lua.pc
	$(INSTALL) $(@D)/src/liblua.a $(STAGING_DIR)/usr/lib
	$(INSTALL) $(@D)/src/lua $(STAGING_DIR)/usr/bin
	$(INSTALL) $(@D)/src/luac $(STAGING_DIR)/usr/bin
	$(INSTALL) $(@D)/src/lua.h $(STAGING_DIR)/usr/include
	$(INSTALL) $(@D)/src/luaconf.h $(STAGING_DIR)/usr/include
	$(INSTALL) $(@D)/src/lualib.h $(STAGING_DIR)/usr/include
	$(INSTALL) $(@D)/src/lauxlib.h $(STAGING_DIR)/usr/include
endef

ifeq ($(BR2_PACKAGE_LUA_INTERPRETER),y)
define LUA_INSTALL_INTERPRETER
	$(INSTALL) $(@D)/src/lua $(TARGET_DIR)/usr/bin
endef
endif

ifeq ($(BR2_PACKAGE_LUA_COMPILER),y)
define LUA_INSTALL_COMPILER
	$(INSTALL) $(@D)/src/luac $(TARGET_DIR)/usr/bin
endef
endif

ifeq ($(BR2_PACKAGE_LUA_SHARED_LIBRARY),y)
define LUA_INSTALL_LIBRARY
	$(INSTALL) $(@D)/src/liblua.so.$(LUA_VERSION) \
		$(TARGET_DIR)/usr/lib/liblua.so.$(LUA_VERSION)
	ln -sf liblua.so.$(LUA_VERSION) $(TARGET_DIR)/usr/lib/liblua.so
	$(INSTALL) $(@D)/src/liblua.a $(TARGET_DIR)/usr/lib/liblua.a
endef
else
define LUA_INSTALL_LIBRARY
	$(INSTALL) $(@D)/src/liblua.a $(TARGET_DIR)/usr/lib/liblua.a
endef
endif

ifeq ($(BR2_HAVE_DEVFILES),y)
define LUA_INSTALL_DEVFILES
	$(INSTALL) -m 0644 -D $(@D)/etc/lua.pc \
		$(TARGET_DIR)/usr/lib/pkgconfig/lua.pc
	$(INSTALL) $(@D)/src/lua.h $(TARGET_DIR)/usr/include
	$(INSTALL) $(@D)/src/luaconf.h $(TARGET_DIR)/usr/include
	$(INSTALL) $(@D)/src/lualib.h $(TARGET_DIR)/usr/include
	$(INSTALL) $(@D)/src/lauxlib.h $(TARGET_DIR)/usr/include
endef
endif

define LUA_INSTALL_TARGET_CMDS
	$(LUA_INSTALL_INTERPRETER)
	$(LUA_INSTALL_COMPILER)
	$(LUA_INSTALL_LIBRARY)
	$(LUA_INSTALL_DEVFILES)
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

define LUA_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS,package,lua))
