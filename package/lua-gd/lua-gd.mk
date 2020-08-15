################################################################################
#
# lua-gd
#
################################################################################

LUA_GD_VERSION = e60b13b7977bb3424d7044976ccba5d42c256934
LUA_GD_SITE = $(call github,ittner,lua-gd,$(LUA_GD_VERSION))
LUA_GD_LICENSE = MIT
LUA_GD_LICENSE_FILES = COPYING
LUA_GD_DEPENDENCIES = luainterpreter gd

# VERSION follows the scheme described on https://ittner.github.io/lua-gd/manual.html#intro,
# the current version of the binding is 3.
define LUA_GD_BUILD_CMDS
	$(MAKE) -C $(@D) gd.so \
		GDLIBCONFIG="$(STAGING_DIR)/usr/bin/gdlib-config" \
		CC=$(TARGET_CC) \
		CFLAGS="$(TARGET_CFLAGS) -fPIC -DVERSION=\\\"$(GD_VERSION)r3\\\"" \
		LFLAGS="-shared -lgd"
endef

define LUA_GD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/gd.so $(TARGET_DIR)/usr/lib/lua/$(LUAINTERPRETER_ABIVER)/gd.so
endef

$(eval $(generic-package))
