################################################################################
#
# libplist
#
################################################################################

LIBPLIST_VERSION = 1.6
LIBPLIST_SITE = http://cgit.sukimashita.com/libplist.git/snapshot
LIBPLIST_DEPENDENCIES = libxml2
LIBPLIST_INSTALL_STAGING = YES
LIBPLIST_MAKE = $(MAKE1)
LIBPLIST_LICENSE = LGPLv2.1+
LIBPLIST_LICENSE_FILES = COPYING

$(eval $(cmake-package))
