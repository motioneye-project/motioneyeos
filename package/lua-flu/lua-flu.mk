################################################################################
#
# lua-flu
#
################################################################################

LUA_FLU_VERSION = 20150331-1
LUA_FLU_NAME_UPSTREAM = Flu
LUA_FLU_SUBDIR = doub-flu-a7daae986339
LUA_FLU_LICENSE = MIT
LUA_FLU_LICENSE_FILES = $(LUA_FLU_SUBDIR)/doc/LICENSE.txt
LUA_FLU_DEPENDENCIES = attr libfuse

$(eval $(luarocks-package))
