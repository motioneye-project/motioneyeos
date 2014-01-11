################################################################################
#
# luaexpat
#
################################################################################

LUAEXPAT_VERSION = 1.2.0-1
LUAEXPAT_DEPENDENCIES = expat
LUAEXPAT_LICENSE = MIT

$(eval $(luarocks-package))
