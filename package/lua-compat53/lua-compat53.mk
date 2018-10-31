################################################################################
#
# lua-compat53
#
################################################################################

LUA_COMPAT53_VERSION_UPSTREAM = 0.7
LUA_COMPAT53_VERSION = $(LUA_COMPAT53_VERSION_UPSTREAM)-1
LUA_COMPAT53_NAME_UPSTREAM = compat53
LUA_COMPAT53_SUBDIR = lua-compat-5.3-$(LUA_COMPAT53_VERSION_UPSTREAM)
LUA_COMPAT53_LICENSE = MIT
LUA_COMPAT53_LICENSE_FILES = $(LUA_COMPAT53_SUBDIR)/LICENSE

$(eval $(luarocks-package))
