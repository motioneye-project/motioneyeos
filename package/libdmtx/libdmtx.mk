################################################################################
#
# libdmtx
#
################################################################################

LIBDMTX_VERSION = 0.7.4
LIBDMTX_SITE = http://downloads.sourceforge.net/project/libdmtx/libdmtx/$(LIBDMTX_VERSION)
LIBDMTX_LICENSE = BSD-2c or Special Permission
LIBDMTX_LICENSE_FILES = LICENSE
LIBDMTX_INSTALL_STAGING = YES

$(eval $(autotools-package))
