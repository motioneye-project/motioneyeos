################################################################################
#
# lsqlite3
#
################################################################################

LSQLITE3_VERSION = 0.9.5-1
LSQLITE3_SUBDIR = lsqlite3_fsl09y
LSQLITE3_LICENSE = MIT
LSQLITE3_DEPENDENCIES = sqlite

$(eval $(luarocks-package))
