################################################################################
#
# libmspack
#
################################################################################

LIBMSPACK_VERSION = 0.10.1alpha
LIBMSPACK_SITE = https://www.cabextract.org.uk/libmspack
LIBMSPACK_LICENSE = LGPL-2.1
LIBMSPACK_LICENSE_FILES = COPYING.LIB
LIBMSPACK_INSTALL_STAGING = YES

$(eval $(autotools-package))
