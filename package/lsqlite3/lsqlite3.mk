################################################################################
#
# lsqlite3
#
################################################################################

LSQLITE3_VERSION = 0.9.3-0
LSQLITE3_SUBDIR = lsqlite3_fsl09w
LSQLITE3_DEPENDENCIES = sqlite
LSQLITE3_LICENSE = MIT

$(eval $(luarocks-package))
