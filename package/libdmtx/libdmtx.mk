################################################################################
#
# libdmtx
#
################################################################################

LIBDMTX_VERSION = 0.7.5
LIBDMTX_SITE = $(call github,dmtx,libdmtx,v$(LIBDMTX_VERSION))
LIBDMTX_LICENSE = BSD-2-Clause or Special Permission
LIBDMTX_LICENSE_FILES = LICENSE
LIBDMTX_INSTALL_STAGING = YES
# github tarball does not include configure
LIBDMTX_AUTORECONF = YES

$(eval $(autotools-package))
