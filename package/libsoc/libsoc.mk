################################################################################
#
# libsoc
#
################################################################################

LIBSOC_VERSION = 0.4
LIBSOC_SITE = http://github.com/jackmitch/libsoc/tarball/$(LIBSOC_VERSION)
LIBSOC_LICENSE = LGPLv2.1
LIBSOC_LICENSE_FILES = COPYING
LIBSOC_AUTORECONF = YES
LIBSOC_INSTALL_STAGING = YES

$(eval $(autotools-package))
