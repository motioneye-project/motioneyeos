################################################################################
#
# lua-fifo
#
################################################################################

LUA_FIFO_VERSION_UPSTREAM =0.2
LUA_FIFO_VERSION =$(LUA_FIFO_VERSION_UPSTREAM)-0
LUA_FIFO_NAME_UPSTREAM = fifo
LUA_FIFO_SUBDIR = fifo.lua-$(LUA_FIFO_VERSION_UPSTREAM)
LUA_FIFO_LICENSE = MIT
LUA_FIFO_LICENSE_FILES = $(LUA_FIFO_SUBDIR)/LICENSE

$(eval $(luarocks-package))
