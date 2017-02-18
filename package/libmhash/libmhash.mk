################################################################################
#
# libmhash
#
################################################################################

LIBMHASH_VERSION = 0.9.9.9
LIBMHASH_SITE = http://downloads.sourceforge.net/project/mhash/mhash/$(LIBMHASH_VERSION)
LIBMHASH_SOURCE = mhash-$(LIBMHASH_VERSION).tar.bz2
LIBMHASH_INSTALL_STAGING = YES
LIBMHASH_LICENSE = LGPLv2
LIBMHASH_LICENSE_FILES = COPYING

$(eval $(autotools-package))
