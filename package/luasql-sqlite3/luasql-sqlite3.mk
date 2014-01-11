################################################################################
#
# luasql-sqlite3
#
################################################################################

LUASQL_SQLITE3_VERSION = v2.3.0
LUASQL_SQLITE3_SITE = https://github.com/keplerproject/luasql/tarball/$(LUASQL_SQLITE3_VERSION)
LUASQL_SQLITE3_LICENSE = MIT
LUASQL_SQLITE3_LICENSE_FILES = README
LUASQL_SQLITE3_DEPENDENCIES = luainterpreter sqlite

LUASQL_SQLITE3_MAKE_FLAGS = \
	CC="$(TARGET_CC)" \
	LD="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS) -fPIC" \
	T="sqlite3" \
	DRIVER_LIBS="-L$(STAGING_DIR)/usr/lib -lsqlite3"

define LUASQL_SQLITE3_BUILD_CMDS
	$(MAKE) -C $(@D) $(LUASQL_SQLITE3_MAKE_FLAGS)
endef

define LUASQL_SQLITE3_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LUASQL_SQLITE3_MAKE_FLAGS) \
		PREFIX="$(TARGET_DIR)/usr" install
endef

define LUASQL_SQLITE3_UNINSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/usr/lib/lua/5.1/luasql
endef

$(eval $(generic-package))
