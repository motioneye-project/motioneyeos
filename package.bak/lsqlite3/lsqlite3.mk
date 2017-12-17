################################################################################
#
# lsqlite3
#
################################################################################

LSQLITE3_VERSION = 0.9.4-2
LSQLITE3_SUBDIR = lsqlite3_fsl09x
LSQLITE3_DEPENDENCIES = sqlite
LSQLITE3_LICENSE = MIT

$(eval $(luarocks-package))
