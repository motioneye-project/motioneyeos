################################################################################
#
# luafilesystem
#
################################################################################

LUAFILESYSTEM_VERSION = 1.7.0-2
LUAFILESYSTEM_LICENSE = MIT
LUAFILESYSTEM_LICENSE_FILES = luafilesystem/LICENSE
LUAFILESYSTEM_SUBDIR = luafilesystem

$(eval $(luarocks-package))
