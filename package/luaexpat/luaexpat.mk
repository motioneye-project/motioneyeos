################################################################################
#
# luaexpat
#
################################################################################

LUAEXPAT_VERSION = 1.3.3-1
LUAEXPAT_DEPENDENCIES = expat
LUAEXPAT_LICENSE = MIT
LUAEXPAT_LICENSE_FILES = $(LUAEXPAT_SUBDIR)/LICENSE

$(eval $(luarocks-package))
