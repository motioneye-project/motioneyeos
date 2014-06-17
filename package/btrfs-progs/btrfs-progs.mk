################################################################################
#
# btrfs-progs
#
################################################################################

BTRFS_PROGS_VERSION = 3.14.2
BTRFS_PROGS_SITE = https://www.kernel.org/pub/linux/kernel/people/mason/btrfs-progs
BTRFS_PROGS_SOURCE = btrfs-progs-v$(BTRFS_PROGS_VERSION).tar.xz
BTRFS_PROGS_DEPENDENCIES = acl attr e2fsprogs lzo util-linux zlib
BTRFS_PROGS_LICENSE = GPLv2
BTRFS_PROGS_LICENSE_FILES = COPYING

define BTRFS_PROGS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define BTRFS_PROGS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) prefix=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
