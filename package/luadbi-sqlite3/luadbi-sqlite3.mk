################################################################################
#
# luadbi-sqlite3
#
################################################################################

LUADBI_SQLITE3_VERSION = 0.6-2
LUADBI_SQLITE3_SUBDIR = luadbi
LUADBI_SQLITE3_LICENSE = MIT
LUADBI_SQLITE3_LICENSE_FILES = $(LUADBI_SQLITE3_SUBDIR)/COPYING
LUADBI_SQLITE3_DEPENDENCIES = sqlite

$(eval $(luarocks-package))
