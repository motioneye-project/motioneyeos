################################################################################
#
# lua-livr-extra
#
################################################################################

LUA_LIVR_EXTRA_VERSION = 0.1.1-1
LUA_LIVR_EXTRA_NAME_UPSTREAM = lua-LIVR-extra
LUA_LIVR_EXTRA_LICENSE = MIT
LUA_LIVR_EXTRA_LICENSE_FILES = $(LUA_LIVR_EXTRA_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
