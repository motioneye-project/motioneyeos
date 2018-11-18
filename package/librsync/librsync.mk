################################################################################
#
# librsync
#
################################################################################

LIBRSYNC_VERSION = v2.0.2
LIBRSYNC_SITE = $(call github,librsync,librsync,$(LIBRSYNC_VERSION))
LIBRSYNC_LICENSE = LGPL-2.1+
LIBRSYNC_LICENSE_FILES = COPYING
LIBRSYNC_INSTALL_STAGING = YES
LIBRSYNC_DEPENDENCIES = zlib bzip2 popt

$(eval $(cmake-package))
