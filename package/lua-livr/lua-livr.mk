################################################################################
#
# lua-livr
#
################################################################################

LUA_LIVR_VERSION = 0.2.1-1
LUA_LIVR_NAME_UPSTREAM = lua-LIVR
LUA_LIVR_LICENSE = MIT
LUA_LIVR_LICENSE_FILES = $(LUA_LIVR_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
