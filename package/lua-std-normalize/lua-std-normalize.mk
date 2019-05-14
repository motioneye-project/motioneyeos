################################################################################
#
# lua-std-normalize
#
################################################################################

LUA_STD_NORMALIZE_VERSION_UPSTREAM = 2.0.2
LUA_STD_NORMALIZE_VERSION = $(LUA_STD_NORMALIZE_VERSION_UPSTREAM)-1
LUA_STD_NORMALIZE_NAME_UPSTREAM = std.normalize
LUA_STD_NORMALIZE_SUBDIR = normalize-$(LUA_STD_NORMALIZE_VERSION_UPSTREAM)
LUA_STD_NORMALIZE_LICENSE = MIT
LUA_STD_NORMALIZE_LICENSE_FILES = $(LUA_STD_NORMALIZE_SUBDIR)/LICENSE.md

$(eval $(luarocks-package))
