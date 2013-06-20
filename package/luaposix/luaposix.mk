################################################################################
#
# luaposix
#
################################################################################

LUAPOSIX_VERSION = 5.1.20
LUAPOSIX_SITE = https://github.com/downloads/luaposix/luaposix
LUAPOSIX_LICENSE = MIT
LUAPOSIX_LICENSE_FILES = COPYING
LUAPOSIX_DEPENDENCIES = lua host-lua
LUAPOSIX_CONF_OPT = --libdir="/usr/lib/lua" --datarootdir="/usr/share/lua"
LUAPOSIX_AUTORECONF = YES

$(eval $(autotools-package))
