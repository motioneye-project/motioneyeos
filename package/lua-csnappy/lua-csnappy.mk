################################################################################
#
# lua-csnappy
#
################################################################################

LUA_CSNAPPY_VERSION_UPSTREAM = 0.1.4
LUA_CSNAPPY_VERSION = $(LUA_CSNAPPY_VERSION_UPSTREAM)-1
LUA_CSNAPPY_SUBDIR = lua-csnappy-$(LUA_CSNAPPY_VERSION_UPSTREAM)
LUA_CSNAPPY_LICENSE = BSD-3c
LUA_CSNAPPY_LICENSE_FILES = $(LUA_CSNAPPY_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
