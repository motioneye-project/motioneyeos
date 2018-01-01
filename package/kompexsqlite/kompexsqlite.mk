################################################################################
#
# kompexsqlite
#
################################################################################

KOMPEXSQLITE_VERSION = v1.10.12-1
KOMPEXSQLITE_SOURCE = $(KOMPEXSQLITE_VERSION).tar.gz
KOMPEXSQLITE_SITE = https://github.com/Aethelflaed/kompex-sqlite-wrapper/archive
KOMPEXSQLITE_INSTALL_STAGING = YES
KOMPEXSQLITE_LICENSE = LGPL-3.0+ (wrapper), Public Domain (bundled sqlite)
KOMPEXSQLITE_LICENSE_FILES = LICENSE.txt

$(eval $(autotools-package))
