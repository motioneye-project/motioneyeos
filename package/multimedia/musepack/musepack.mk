################################################################################
#
# musepack
#
################################################################################

MUSEPACK_VERSION =  r475
MUSEPACK_SITE = http://files.musepack.net/source
MUSEPACK_SOURCE = musepack_src_$(MUSEPACK_VERSION).tar.gz
MUSEPACK_DEPENDENCIES = libcuefile libreplaygain
MUSEPACK_INSTALL_STAGING = YES
MUSEPACK_MAKE = $(MAKE1)

$(eval $(cmake-package))
