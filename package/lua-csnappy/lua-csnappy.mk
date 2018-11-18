################################################################################
#
# lua-csnappy
#
################################################################################

LUA_CSNAPPY_VERSION = 0.1.5-1
LUA_CSNAPPY_LICENSE = BSD-3-Clause
LUA_CSNAPPY_LICENSE_FILES = $(LUA_CSNAPPY_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
