################################################################################
#
# e2fsprogs
#
################################################################################

E2FSPROGS_VERSION = 1.42.13
E2FSPROGS_SOURCE = e2fsprogs-$(E2FSPROGS_VERSION).tar.xz
E2FSPROGS_SITE = $(BR2_KERNEL_MIRROR)/linux/kernel/people/tytso/e2fsprogs/v$(E2FSPROGS_VERSION)
E2FSPROGS_LICENSE = GPLv2, libuuid BSD-3c, libss and libet MIT-like with advertising clause
E2FSPROGS_LICENSE_FILES = COPYING lib/uuid/COPYING lib/ss/mit-sipb-copyright.h lib/et/internal.h
E2FSPROGS_INSTALL_STAGING = YES
E2FSPROGS_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) install-libs

# e4defrag doesn't build on older systems like RHEL5.x, and we don't
# need it on the host anyway.
HOST_E2FSPROGS_CONF_OPTS += --disable-defrag

E2FSPROGS_CONF_OPTS = \
	$(if $(BR2_STATIC_LIBS),,--enable-elf-shlibs) \
	$(if $(BR2_PACKAGE_E2FSPROGS_DEBUGFS),,--disable-debugfs) \
	$(if $(BR2_PACKAGE_E2FSPROGS_E2IMAGE),,--disable-imager) \
	$(if $(BR2_PACKAGE_E2FSPROGS_E4DEFRAG),,--disable-defrag) \
	$(if $(BR2_PACKAGE_E2FSPROGS_RESIZE2FS),,--disable-resizer) \
	--disable-uuidd \
	--disable-libblkid \
	--disable-libuuid \
	--enable-fsck \
	--disable-e2initrd-helper \
	--disable-testio-debug \
	--disable-rpath

ifeq ($(BR2_nios2),y)
E2FSPROGS_CONF_ENV += ac_cv_func_fallocate=no
endif

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
# util-linux libuuid pulls in libintl if needed, so ensure we also
# link against it, otherwise static linking fails
E2FSPROGS_CONF_ENV += LIBS=-lintl
endif

E2FSPROGS_DEPENDENCIES = host-pkgconf util-linux

E2FSPROGS_MAKE_OPTS = \
	LDCONFIG=true

define HOST_E2FSPROGS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install install-libs
endef
# we don't have a host-util-linux
HOST_E2FSPROGS_DEPENDENCIES = host-pkgconf

# binaries to keep or remove
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_BADBLOCKS) += usr/sbin/badblocks
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_CHATTR) += usr/bin/chattr
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_DUMPE2FS) += usr/sbin/dumpe2fs
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2FREEFRAG) += usr/sbin/e2freefrag
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2FSCK) += usr/sbin/e2fsck
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2LABEL) += usr/sbin/e2label
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2UNDO) += usr/sbin/e2undo
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E4DEFRAG) += usr/sbin/e4defrag
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_FILEFRAG) += usr/sbin/filefrag
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_FSCK) += usr/sbin/fsck
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_LOGSAVE) += usr/sbin/logsave
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_LSATTR) += usr/bin/lsattr
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_MKE2FS) += usr/sbin/mke2fs
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_MKLOSTFOUND) += usr/sbin/mklost+found
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_UUIDGEN) += usr/bin/uuidgen

# files to remove
E2FSPROGS_TXTTARGETS_ = \
	usr/sbin/mkfs.ext[234] \
	usr/sbin/mkfs.ext4dev \
	usr/sbin/fsck.ext[234] \
	usr/sbin/fsck.ext4dev \
	usr/sbin/findfs \
	usr/sbin/tune2fs

define E2FSPROGS_TARGET_REMOVE_UNNEEDED
	rm -f $(addprefix $(TARGET_DIR)/, $(E2FSPROGS_BINTARGETS_))
	rm -f $(addprefix $(TARGET_DIR)/, $(E2FSPROGS_TXTTARGETS_))
endef

E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_TARGET_REMOVE_UNNEEDED

define E2FSPROGS_TARGET_MKE2FS_SYMLINKS
	ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext2
	ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext3
	ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext4
	ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext4dev
endef

ifeq ($(BR2_PACKAGE_E2FSPROGS_MKE2FS),y)
E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_TARGET_MKE2FS_SYMLINKS
endif

define E2FSPROGS_TARGET_E2FSCK_SYMLINKS
	ln -sf e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext2
	ln -sf e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext3
	ln -sf e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext4
	ln -sf e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext4dev
endef

ifeq ($(BR2_PACKAGE_E2FSPROGS_E2FSCK),y)
E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_TARGET_E2FSCK_SYMLINKS
endif

# Remove busybox tune2fs and e2label, since we want the e2fsprogs full
# blown variants to take precedence, but they are not installed in the
# same location.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
E2FSPROGS_DEPENDENCIES += busybox

define E2FSPROGS_REMOVE_BUSYBOX_APPLETS
	$(RM) -f $(TARGET_DIR)/bin/chattr
	$(RM) -f $(TARGET_DIR)/bin/lsattr
	$(RM) -f $(TARGET_DIR)/sbin/fsck
	$(RM) -f $(TARGET_DIR)/sbin/tune2fs
	$(RM) -f $(TARGET_DIR)/sbin/e2label
endef
E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_REMOVE_BUSYBOX_APPLETS
endif

define E2FSPROGS_TARGET_TUNE2FS_SYMLINK
	ln -sf e2label $(TARGET_DIR)/usr/sbin/tune2fs
endef

ifeq ($(BR2_PACKAGE_E2FSPROGS_TUNE2FS),y)
E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_TARGET_TUNE2FS_SYMLINK
endif

define E2FSPROGS_TARGET_FINDFS_SYMLINK
	ln -sf e2label $(TARGET_DIR)/usr/sbin/findfs
endef

ifeq ($(BR2_PACKAGE_E2FSPROGS_FINDFS),y)
E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_TARGET_FINDFS_SYMLINK
endif

# systemd really wants to have fsck in /sbin
define E2FSPROGS_TARGET_FSCK_SYMLINK
	ln -sf ../usr/sbin/fsck $(TARGET_DIR)/sbin/fsck
endef

ifeq ($(BR2_PACKAGE_E2FSPROGS_FSCK),y)
E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_TARGET_FSCK_SYMLINK
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
