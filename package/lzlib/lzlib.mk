################################################################################
#
# lzlib
#
################################################################################

LZLIB_VERSION = 0.4.work3-1
LZLIB_SUBDIR = lzlib-0.4-work3
LZLIB_DEPENDENCIES = zlib
LZLIB_LICENSE = MIT

$(eval $(luarocks-package))
