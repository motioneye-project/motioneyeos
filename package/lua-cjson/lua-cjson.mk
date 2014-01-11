################################################################################
#
# lua-cjson
#
################################################################################

LUA_CJSON_VERSION       = 2.1.0
LUA_CJSON_SITE          = http://www.kyne.com.au/~mark/software/download
LUA_CJSON_DEPENDENCIES  = luainterpreter
LUA_CJSON_LICENSE       = MIT
LUA_CJSON_LICENSE_FILES = LICENSE

define LUA_CJSON_BUILD_CMDS
	$(MAKE) -C $(@D) \
		CFLAGS="$(TARGET_CFLAGS)"   \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		CC="$(TARGET_CC)"           \
		LD="$(TARGET_LD)"           \
		PREFIX=$(STAGING_DIR)/usr
endef

define LUA_CJSON_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR="$(TARGET_DIR)" PREFIX="/usr" -C $(@D) install
endef

$(eval $(generic-package))
