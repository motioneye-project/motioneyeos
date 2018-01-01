################################################################################
#
# libdvbsi
#
################################################################################

LIBDVBSI_VERSION = 0.3.7
LIBDVBSI_SOURCE = libdvbsi++-$(LIBDVBSI_VERSION).tar.bz2
LIBDVBSI_SITE = http://www.saftware.de/libdvbsi++
LIBDVBSI_INSTALL_STAGING = YES
LIBDVBSI_LICENSE = LGPL-2.1
LIBDVBSI_LICENSE_FILES = COPYING

$(eval $(autotools-package))
