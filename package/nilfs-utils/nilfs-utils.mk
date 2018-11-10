################################################################################
#
# nilfs-utils
#
################################################################################

NILFS_UTILS_VERSION = v2.2.7
NILFS_UTILS_SITE = $(call github,nilfs-dev,nilfs-utils,$(NILFS_UTILS_VERSION))
NILFS_UTILS_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
NILFS_UTILS_LICENSE_FILES = COPYING

# need libuuid, libblkid, libmount
NILFS_UTILS_DEPENDENCIES = host-pkgconf util-linux

# we're fetching from github
NILFS_UTILS_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
NILFS_UTILS_CONF_OPTS += --with-selinux
NILFS_UTILS_DEPENDENCIES += libselinux
else
NILFS_UTILS_CONF_OPTS += --without-selinux
endif

$(eval $(autotools-package))
