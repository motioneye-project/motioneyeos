################################################################################
#
# lua-ev
#
################################################################################

LUA_EV_VERSION = 339426fbe528f11cb3cd1af69a88f06bba367981
LUA_EV_SITE = $(call github,brimworks,lua-ev,$(LUA_EV_VERSION))
LUA_EV_DEPENDENCIES = luainterpreter libev
LUA_EV_LICENSE = MIT
LUA_EV_LICENSE_FILES = README
LUA_EV_CONF_OPTS = -DINSTALL_CMOD="/usr/lib/lua/$(LUAINTERPRETER_ABIVER)"

$(eval $(cmake-package))
