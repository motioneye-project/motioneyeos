################################################################################
#
# lua-stdlib
#
################################################################################

LUA_STDLIB_VERSION_UPSTREAM = 41.2.2
LUA_STDLIB_VERSION = $(LUA_STDLIB_VERSION_UPSTREAM)-1
LUA_STDLIB_NAME_UPSTREAM = stdlib
LUA_STDLIB_SUBDIR = lua-stdlib-release-v$(LUA_STDLIB_VERSION_UPSTREAM)
LUA_STDLIB_LICENSE = MIT
LUA_STDLIB_LICENSE_FILES = $(LUA_STDLIB_SUBDIR)/COPYING

$(eval $(luarocks-package))
