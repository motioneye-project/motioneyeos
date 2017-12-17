################################################################################
#
# luafilesystem
#
################################################################################

LUAFILESYSTEM_VERSION = 1.6.3-1
LUAFILESYSTEM_LICENSE = MIT
LUAFILESYSTEM_LICENSE_FILES = luafilesystem/LICENSE
LUAFILESYSTEM_SUBDIR = luafilesystem

$(eval $(luarocks-package))
