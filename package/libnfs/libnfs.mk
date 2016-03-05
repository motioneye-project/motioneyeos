################################################################################
#
# libnfs
#
################################################################################

LIBNFS_VERSION = libnfs-1.9.8
LIBNFS_SITE = $(call github,sahlberg,libnfs,$(LIBNFS_VERSION))
LIBNFS_INSTALL_STAGING = YES
LIBNFS_AUTORECONF = YES
LIBNFS_MAKE = $(MAKE1)
LIBNFS_LICENSE = LGPLv2.1+
LIBNFS_LICENSE_FILES = LICENCE-LGPL-2.1.txt
LIBNFS_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
LIBNFS_DEPENDENCIES += libtirpc
endif

# Needed for autoreconf
define LIBNFS_MAKE_M4_DIR
	mkdir $(@D)/m4
endef
LIBNFS_POST_EXTRACT_HOOKS += LIBNFS_MAKE_M4_DIR

$(eval $(autotools-package))
