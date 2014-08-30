################################################################################
#
# btrfs-progs
#
################################################################################

BTRFS_PROGS_VERSION = 3.16
BTRFS_PROGS_SITE = https://www.kernel.org/pub/linux/kernel/people/mason/btrfs-progs
BTRFS_PROGS_SOURCE = btrfs-progs-v$(BTRFS_PROGS_VERSION).tar.xz
BTRFS_PROGS_DEPENDENCIES = acl attr e2fsprogs lzo util-linux zlib
BTRFS_PROGS_LICENSE = GPLv2
BTRFS_PROGS_LICENSE_FILES = COPYING

BTRFS_PROGS_MAKE_FLAGS = DISABLE_DOCUMENTATION=1

ifeq ($(BR2_PREFER_STATIC_LIB),y)
BTRFS_PROGS_MAKE_TARGET = static
BTRFS_PROGS_MAKE_INSTALL_TARGET = install-static
else
BTRFS_PROGS_MAKE_TARGET = all
BTRFS_PROGS_MAKE_INSTALL_TARGET = install
endif

define BTRFS_PROGS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(BTRFS_PROGS_MAKE_FLAGS) $(BTRFS_PROGS_MAKE_TARGET)
endef

define BTRFS_PROGS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) prefix=/usr DESTDIR=$(TARGET_DIR) \
		$(BTRFS_PROGS_MAKE_FLAGS) $(BTRFS_PROGS_MAKE_INSTALL_TARGET)
endef

$(eval $(generic-package))
