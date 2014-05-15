################################################################################
#
# lua
#
################################################################################

ifeq ($(BR2_PACKAGE_LUA_5_2),y)
LUA_VERSION = 5.2.3
else
LUA_VERSION = 5.1.5
endif
LUA_SITE = http://www.lua.org/ftp
LUA_INSTALL_STAGING = YES
LUA_LICENSE = MIT
LUA_LICENSE_FILES = COPYRIGHT

LUA_PROVIDES = luainterpreter

LUA_CFLAGS = -Wall -fPIC -DLUA_USE_POSIX

ifeq ($(BR2_PACKAGE_LUA_5_2),y)
LUA_CFLAGS += -DLUA_COMPAT_ALL
ifneq ($(BR2_LARGEFILE),y)
LUA_CFLAGS += -D_FILE_OFFSET_BITS=32
endif
endif

ifeq ($(BR2_PREFER_STATIC_LIB),y)
	LUA_BUILDMODE = static
else
	LUA_BUILDMODE = dynamic
	LUA_CFLAGS += -DLUA_USE_DLOPEN
	LUA_MYLIBS += -ldl
endif

ifeq ($(BR2_PACKAGE_LUA_READLINE),y)
	LUA_DEPENDENCIES = readline ncurses
	LUA_MYLIBS += -lreadline -lhistory -lncurses
	LUA_CFLAGS += -DLUA_USE_READLINE
else
ifeq ($(BR2_PACKAGE_LUA_LINENOISE),y)
	LUA_DEPENDENCIES = linenoise
	LUA_MYLIBS += -llinenoise
	LUA_CFLAGS += -DLUA_USE_LINENOISE
endif
endif

# We never want to have host-readline and host-ncurses as dependencies
# of host-lua.
HOST_LUA_DEPENDENCIES =
HOST_LUA_CFLAGS = -Wall -fPIC -DLUA_USE_DLOPEN -DLUA_USE_POSIX
HOST_LUA_MYLIBS = -ldl

ifeq ($(BR2_PACKAGE_LUA_5_2),y)
HOST_LUA_CFLAGS += -DLUA_COMPAT_ALL
endif

define LUA_BUILD_CMDS
	$(MAKE) \
	CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" \
	CFLAGS="$(TARGET_CFLAGS) $(LUA_CFLAGS)" \
	MYLIBS="$(LUA_MYLIBS)" AR="$(TARGET_CROSS)ar rcu" \
	BUILDMODE=$(LUA_BUILDMODE) \
	PKG_VERSION=$(LUA_VERSION) -C $(@D)/src all
endef

define HOST_LUA_BUILD_CMDS
	$(MAKE) \
	CFLAGS="$(HOST_LUA_CFLAGS)" \
	MYLDFLAGS="$(HOST_LDFLAGS)" \
	MYLIBS="$(HOST_LUA_MYLIBS)" \
	BUILDMODE=static \
	PKG_VERSION=$(LUA_VERSION) -C $(@D)/src all
endef

define LUA_INSTALL_STAGING_CMDS
	$(MAKE) INSTALL_TOP="$(STAGING_DIR)/usr" -C $(@D) install
	$(INSTALL) -m 0644 -D $(@D)/etc/lua.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/lua.pc
endef

define LUA_INSTALL_TARGET_CMDS
	$(MAKE) INSTALL_TOP="$(TARGET_DIR)/usr" -C $(@D) install
endef

define HOST_LUA_INSTALL_CMDS
	$(MAKE) INSTALL_TOP="$(HOST_DIR)/usr" -C $(@D) install
	$(INSTALL) -m 0644 -D $(@D)/etc/lua.pc \
		$(HOST_DIR)/usr/lib/pkgconfig/lua.pc
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
