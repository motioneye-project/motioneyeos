################################################################################
#
# libuecc
#
################################################################################

LIBUECC_VERSION = v6
LIBUECC_SITE = git://git.universe-factory.net/libuecc
LIBUECC_LICENSE = BSD-2c
LIBUECC_LICENSE_FILES = COPYRIGHT
LIBUECC_INSTALL_STAGING = YES

$(eval $(cmake-package))
