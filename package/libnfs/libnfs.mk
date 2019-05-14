################################################################################
#
# libnfs
#
################################################################################

LIBNFS_VERSION = libnfs-3.0.0
LIBNFS_SITE = $(call github,sahlberg,libnfs,$(LIBNFS_VERSION))
LIBNFS_INSTALL_STAGING = YES
LIBNFS_AUTORECONF = YES
LIBNFS_LICENSE = LGPL-2.1+ (library), BSD-2-Clause (protocol, .x files), GPL-3.0+ (examples)
LIBNFS_LICENSE_FILES = COPYING LICENCE-BSD.txt LICENCE-LGPL-2.1.txt LICENCE-GPL-3.txt
LIBNFS_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
LIBNFS_DEPENDENCIES += libtirpc
endif

$(eval $(autotools-package))
