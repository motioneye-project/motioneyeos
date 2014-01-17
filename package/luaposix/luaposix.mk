################################################################################
#
# luaposix
#
################################################################################

LUAPOSIX_VERSION = 31
LUAPOSIX_SITE = https://github.com/luaposix/luaposix/archive
LUAPOSIX_SOURCE = release-v$(LUAPOSIX_VERSION).tar.gz
LUAPOSIX_LICENSE = MIT
LUAPOSIX_LICENSE_FILES = COPYING
LUAPOSIX_DEPENDENCIES = luainterpreter host-lua
LUAPOSIX_CONF_OPT = --libdir="/usr/lib/lua/$(LUAINTERPRETER_ABIVER)" --datarootdir="/usr/share/lua/$(LUAINTERPRETER_ABIVER)"

ifeq ($(BR2_PACKAGE_NCURSES),y)
    LUAPOSIX_DEPENDENCIES += ncurses
endif

$(eval $(autotools-package))
