################################################################################
#
# btrfs-progs
#
################################################################################

BTRFS_PROGS_VERSION = 5.2.1
BTRFS_PROGS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/people/kdave/btrfs-progs
BTRFS_PROGS_SOURCE = btrfs-progs-v$(BTRFS_PROGS_VERSION).tar.xz
BTRFS_PROGS_DEPENDENCIES = host-pkgconf lzo util-linux zlib
BTRFS_PROGS_CONF_OPTS = --disable-backtrace --disable-zstd --disable-python
BTRFS_PROGS_LICENSE = GPL-2.0, LGPL-3.0+ (libbtrfsutil)
BTRFS_PROGS_LICENSE_FILES = COPYING libbtrfsutil/COPYING \
	libbtrfsutil/COPYING.LESSER
BTRFS_PROGS_INSTALL_STAGING = YES

# Doesn't autodetect static-only and tries to build both
ifeq ($(BR2_STATIC_LIBS),y)
BTRFS_PROGS_MAKE_OPTS = static
BTRFS_PROGS_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install-static
BTRFS_PROGS_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) install-static
endif

# convert also supports conversion from reiserfs, which needs some
# reiserfs libraries, but we have no package for them in Buildroot, so
# we keep things simple and only handle ext2.
ifeq ($(BR2_PACKAGE_E2FSPROGS),y)
BTRFS_PROGS_CONF_OPTS += --enable-convert --with-convert=ext2
BTRFS_PROGS_DEPENDENCIES += e2fsprogs
else
BTRFS_PROGS_CONF_OPTS += --disable-convert
endif

HOST_BTRFS_PROGS_DEPENDENCIES = host-util-linux host-lzo host-zlib
HOST_BTRFS_PROGS_CONF_OPTS = \
	--disable-backtrace \
	--disable-zstd \
	--disable-python \
	--disable-convert

$(eval $(autotools-package))
$(eval $(host-autotools-package))
