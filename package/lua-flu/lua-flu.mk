################################################################################
#
# lua-flu
#
################################################################################

LUA_FLU_VERSION = 20181218-1
LUA_FLU_NAME_UPSTREAM = Flu
LUA_FLU_SUBDIR = doub-flu-63f077a988cd
LUA_FLU_LICENSE = MIT
LUA_FLU_LICENSE_FILES = $(LUA_FLU_SUBDIR)/doc/LICENSE.txt
LUA_FLU_DEPENDENCIES = attr libfuse

$(eval $(luarocks-package))
