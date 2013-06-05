################################################################################
#
# librsync
#
################################################################################

LIBRSYNC_VERSION = 0.9.7
LIBRSYNC_SOURCE = librsync-$(LIBRSYNC_VERSION).tar.gz
LIBRSYNC_SITE = http://downloads.sourceforge.net/project/librsync/librsync/$(LIBRSYNC_VERSION)
LIBRSYNC_LICENSE = LGPLv2.1+
LIBRSYNC_LICENSE_FILES = COPYING
LIBRSYNC_INSTALL_STAGING = YES
LIBRSYNC_DEPENDENCIES = zlib bzip2 popt

$(eval $(autotools-package))
