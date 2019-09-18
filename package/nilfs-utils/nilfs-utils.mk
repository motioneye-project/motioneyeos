################################################################################
#
# nilfs-utils
#
################################################################################

NILFS_UTILS_VERSION = 2.2.8
NILFS_UTILS_SOURCE = nilfs-utils-$(NILFS_UTILS_VERSION).tar.bz2
NILFS_UTILS_SITE = https://nilfs.sourceforge.io/download
NILFS_UTILS_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
NILFS_UTILS_LICENSE_FILES = COPYING

# need libuuid, libblkid, libmount
NILFS_UTILS_DEPENDENCIES = util-linux

# We're patching sbin/cleanerd/Makefile.am
NILFS_UTILS_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
NILFS_UTILS_CONF_OPTS += --with-selinux
NILFS_UTILS_DEPENDENCIES += libselinux
else
NILFS_UTILS_CONF_OPTS += --without-selinux
endif

$(eval $(autotools-package))
