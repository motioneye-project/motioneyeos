################################################################################
#
# kompexsqlite
#
################################################################################

KOMPEXSQLITE_VERSION = 1.10.12-1
KOMPEXSQLITE_SITE = \
	$(call github,Aethelflaed,kompex-sqlite-wrapper,v$(KOMPEXSQLITE_VERSION))
KOMPEXSQLITE_INSTALL_STAGING = YES
KOMPEXSQLITE_LICENSE = LGPL-3.0+ (wrapper), Public Domain (bundled sqlite)
KOMPEXSQLITE_LICENSE_FILES = LICENSE.txt

$(eval $(autotools-package))
