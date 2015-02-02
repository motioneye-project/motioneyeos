################################################################################
#
# lua-testmore
#
################################################################################

LUA_TESTMORE_VERSION_UPSTREAM = 0.3.2
LUA_TESTMORE_VERSION = $(LUA_TESTMORE_VERSION_UPSTREAM)-1
LUA_TESTMORE_SUBDIR = lua-TestMore-$(LUA_TESTMORE_VERSION_UPSTREAM)
LUA_TESTMORE_LICENSE = MIT
LUA_TESTMORE_LICENSE_FILES = $(LUA_TESTMORE_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
