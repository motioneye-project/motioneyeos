################################################################################
#
# libmhash
#
################################################################################

LIBMHASH_VERSION = 0.9.9.9
LIBMHASH_SITE = http://downloads.sourceforge.net/project/mhash/mhash/$(LIBMHASH_VERSION)
LIBMHASH_SOURCE = mhash-$(LIBMHASH_VERSION).tar.bz2
LIBMHASH_INSTALL_STAGING = YES
# libtool 1.5 patch failure
LIBMHASH_AUTORECONF = YES
LIBMHASH_LICENSE = LGPLv2
LIBMHASH_LICENSE_FILES = COPYING

# Two trees in the tarball cause autoreconf problems
define LIBMHASH_REMOVE_DUPLICATE
	$(RM) -rf $(@D)/mhash-0.9.9
endef
LIBMHASH_POST_EXTRACT_HOOKS += LIBMHASH_REMOVE_DUPLICATE

$(eval $(autotools-package))
