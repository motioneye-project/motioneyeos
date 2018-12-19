################################################################################
#
# luaexpat
#
################################################################################

LUAEXPAT_VERSION = 1.3.3-1
LUAEXPAT_LICENSE = MIT
LUAEXPAT_LICENSE_FILES = $(LUAEXPAT_SUBDIR)/LICENSE
LUAEXPAT_DEPENDENCIES = expat

$(eval $(luarocks-package))
