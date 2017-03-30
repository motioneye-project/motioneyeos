################################################################################
#
# libucl
#
################################################################################

LIBUCL_VERSION = 0.7.3
LIBUCL_SITE = $(call github,vstakhov,libucl,$(LIBUCL_VERSION))
LIBUCL_INSTALL_STAGING = YES
LIBUCL_AUTORECONF = YES
LIBUCL_LICENSE = BSD-2-Clause
LIBUCL_LICENSE_FILES = COPYING
LIBUCL_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
