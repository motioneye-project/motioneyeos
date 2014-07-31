################################################################################
#
# librsync
#
################################################################################

LIBRSYNC_VERSION = 0.9.7
LIBRSYNC_SITE = http://downloads.sourceforge.net/project/librsync/librsync/$(LIBRSYNC_VERSION)
# libtool 1.5 patch failure
LIBRSYNC_AUTORECONF = YES
LIBRSYNC_LICENSE = LGPLv2.1+
LIBRSYNC_LICENSE_FILES = COPYING
LIBRSYNC_INSTALL_STAGING = YES
LIBRSYNC_DEPENDENCIES = zlib bzip2 popt

$(eval $(autotools-package))
