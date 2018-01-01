################################################################################
#
# luaexpat
#
################################################################################

LUAEXPAT_VERSION = 1.3.0-1
LUAEXPAT_DEPENDENCIES = expat
LUAEXPAT_LICENSE = MIT
LUAEXPAT_LICENSE_FILES = $(LUAEXPAT_SUBDIR)/doc/us/license.html

$(eval $(luarocks-package))
