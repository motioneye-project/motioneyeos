################################################################################
#
# lzlib
#
################################################################################

LZLIB_VERSION = 0.4.3
LZLIB_SITE = $(call github,LuaDist,lzlib,$(LZLIB_VERSION))
LZLIB_DEPENDENCIES = lua zlib
LZLIB_LICENSE = MIT
LZLIB_CONF_OPTS = -DINSTALL_CMOD="/usr/lib/lua/$(LUAINTERPRETER_ABIVER)" \
	-DINSTALL_LMOD="/usr/share/lua/$(LUAINTERPRETER_ABIVER)"

$(eval $(cmake-package))
