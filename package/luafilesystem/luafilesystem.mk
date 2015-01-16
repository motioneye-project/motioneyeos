################################################################################
#
# luafilesystem
#
################################################################################

LUAFILESYSTEM_VERSION = 1.6.3-1
LUAFILESYSTEM_LICENSE = MIT
LUAFILESYSTEM_SUBDIR = luafilesystem
ifneq ($(BR2_LARGEFILE),y)
LUAFILESYSTEM_BUILD_OPTS += CFLAGS="$(LUAROCKS_CFLAGS) -DLFS_DO_NOT_USE_LARGE_FILE"
endif

$(eval $(luarocks-package))
