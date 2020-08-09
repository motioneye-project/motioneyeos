################################################################################
#
# lua-codegen
#
################################################################################

LUA_CODEGEN_VERSION = 0.3.3-1
LUA_CODEGEN_NAME_UPSTREAM = lua-CodeGen
LUA_CODEGEN_LICENSE = MIT
LUA_CODEGEN_LICENSE_FILES = $(LUA_CODEGEN_SUBDIR)/COPYRIGHT

$(eval $(luarocks-package))
