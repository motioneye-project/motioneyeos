################################################################################
#
# luafilesystem
#
################################################################################

LUAFILESYSTEM_VERSION = 1.8.0-1
LUAFILESYSTEM_SUBDIR = luafilesystem
LUAFILESYSTEM_LICENSE = MIT
LUAFILESYSTEM_LICENSE_FILES = $(LUAFILESYSTEM_SUBDIR)/LICENSE

$(eval $(luarocks-package))
