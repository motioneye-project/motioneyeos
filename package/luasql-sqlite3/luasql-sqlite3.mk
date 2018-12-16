################################################################################
#
# luasql-sqlite3
#
################################################################################

LUASQL_SQLITE3_VERSION = 2.4.0-1
LUASQL_SQLITE3_SUBDIR = luasql
LUASQL_SQLITE3_LICENSE = MIT
LUASQL_SQLITE3_LICENSE_FILES = $(LUASQL_SQLITE3_SUBDIR)/doc/us/license.html
LUASQL_SQLITE3_DEPENDENCIES = sqlite

$(eval $(luarocks-package))
