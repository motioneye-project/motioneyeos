################################################################################
#
# libsoc
#
################################################################################

LIBSOC_VERSION = 356760dcb93b22d6c67c5232cde2ade8c968c932
LIBSOC_SITE = http://github.com/jackmitch/libsoc/tarball/$(LIBSOC_VERSION)
LIBSOC_LICENSE = LGPLv2.1
LIBSOC_LICENSE_FILES = COPYING
LIBSOC_AUTORECONF = YES
LIBSOC_INSTALL_STAGING = YES

$(eval $(autotools-package))
