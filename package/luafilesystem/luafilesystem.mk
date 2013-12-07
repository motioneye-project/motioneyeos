################################################################################
#
# luafilesystem
#
################################################################################

LUAFILESYSTEM_VERSION = 1.6.2
LUAFILESYSTEM_SITE = http://github.com/downloads/keplerproject/luafilesystem
LUAFILESYSTEM_DEPENDENCIES = lua
LUAFILESYSTEM_LICENSE = MIT

ifeq ($(BR2_LARGEFILE),y)
LFS_CFLAGS = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE
endif

define LUAFILESYSTEM_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS) $(LFS_CFLAGS) -fPIC"
endef

define LUAFILESYSTEM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/lfs.so $(TARGET_DIR)/usr/lib/lua/lfs.so
endef

$(eval $(generic-package))
