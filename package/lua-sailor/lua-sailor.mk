################################################################################
#
# lua-sailor
#
################################################################################

LUA_SAILOR_VERSION = 0.5-4
LUA_SAILOR_NAME_UPSTREAM = sailor
LUA_SAILOR_SUBDIR = sailor
LUA_SAILOR_LICENSE = MIT
LUA_SAILOR_LICENSE_FILES = $(LUA_SAILOR_SUBDIR)/LICENSE

$(eval $(luarocks-package))
