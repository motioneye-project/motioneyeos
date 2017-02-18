################################################################################
#
# luaposix
#
################################################################################

LUAPOSIX_VERSION = 33.4.0
LUAPOSIX_SITE = $(call github,luaposix,luaposix,release-v$(LUAPOSIX_VERSION))
LUAPOSIX_LICENSE = MIT
LUAPOSIX_LICENSE_FILES = COPYING
LUAPOSIX_DEPENDENCIES = luainterpreter host-lua
LUAPOSIX_CONF_OPTS = --libdir="/usr/lib/lua/$(LUAINTERPRETER_ABIVER)" --datarootdir="/usr/share/lua/$(LUAINTERPRETER_ABIVER)"

$(eval $(autotools-package))
