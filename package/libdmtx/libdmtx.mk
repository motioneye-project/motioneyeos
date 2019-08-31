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

# Create the m4 directory (missing from the archive).
# This is required for autoconf.
define LIBDMTX_CREATE_M4
	mkdir -p $(@D)/m4
endef
LIBDMTX_PRE_CONFIGURE_HOOKS += LIBDMTX_CREATE_M4

$(eval $(autotools-package))
