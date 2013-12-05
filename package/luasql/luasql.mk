################################################################################
#
# luasql
#
################################################################################

LUASQL_VERSION = v2.3.0
LUASQL_SITE = $(call github,keplerproject,luasql,$(LUASQL_VERSION))
LUASQL_LICENSE = MIT
LUASQL_LICENSE_FILES = README
LUASQL_DEPENDENCIES = lua

LUASQL_MAKE_FLAGS = \
	CC="$(TARGET_CC)" \
	LD="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS) -fPIC"

ifeq ($(BR2_PACKAGE_LUASQL_DRIVER_SQLITE3),y)
LUASQL_DEPENDENCIES += sqlite
LUASQL_MAKE_FLAGS += \
	T="sqlite3" \
	DRIVER_LIBS="-L$(STAGING_DIR)/usr/lib -lsqlite3"
endif

define LUASQL_BUILD_CMDS
	$(MAKE) -C $(@D) $(LUASQL_MAKE_FLAGS)
endef

define LUASQL_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LUASQL_MAKE_FLAGS) PREFIX=/usr \
		LUA_DIR="$(TARGET_DIR)/usr/share/lua" \
		LUA_LIBDIR="$(TARGET_DIR)/usr/lib/lua" install
endef

$(eval $(generic-package))
