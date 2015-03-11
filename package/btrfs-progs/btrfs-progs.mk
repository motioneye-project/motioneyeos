################################################################################
#
# btrfs-progs
#
################################################################################

BTRFS_PROGS_VERSION = 3.19
BTRFS_PROGS_SITE = https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs
BTRFS_PROGS_SOURCE = btrfs-progs-v$(BTRFS_PROGS_VERSION).tar.xz
BTRFS_PROGS_DEPENDENCIES = host-pkgconf acl attr e2fsprogs lzo util-linux zlib
BTRFS_PROGS_CONF_OPTS = --disable-backtrace
BTRFS_PROGS_LICENSE = GPLv2
BTRFS_PROGS_LICENSE_FILES = COPYING

# Doesn't autodetect static-only and tries to build both
ifeq ($(BR2_STATIC_LIBS),y)
BTRFS_PROGS_MAKE_OPTS = static
BTRFS_PROGS_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-static
endif

$(eval $(autotools-package))
