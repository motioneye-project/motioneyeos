################################################################################
#
# lua-rotas
#
################################################################################

LUA_ROTAS_VERSION = 0.2.0-1
LUA_ROTAS_NAME_UPSTREAM = lua-Rotas
LUA_ROTAS_LICENSE = MIT
LUA_ROTAS_LICENSE_FILES = $(LUA_ROTAS_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
