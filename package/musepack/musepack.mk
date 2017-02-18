################################################################################
#
# musepack
#
################################################################################

MUSEPACK_VERSION = r475
MUSEPACK_SITE = http://files.musepack.net/source
MUSEPACK_SOURCE = musepack_src_$(MUSEPACK_VERSION).tar.gz
MUSEPACK_DEPENDENCIES = libcuefile libreplaygain
MUSEPACK_INSTALL_STAGING = YES
MUSEPACK_MAKE = $(MAKE1)
MUSEPACK_LICENSE = BSD-3c (*mpcdec), LGPLv2.1+ (*mpcenc)
MUSEPACK_LICENSE_FILES = libmpcdec/COPYING libmpcenc/quant.c

$(eval $(cmake-package))
