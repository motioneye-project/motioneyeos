#############################################################
#
# e2fsprogs
#
#############################################################

E2FSPROGS_VERSION = 1.41.14
E2FSPROGS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/e2fsprogs
E2FSPROGS_INSTALL_STAGING = YES

E2FSPROGS_CONF_OPT = \
	--disable-tls \
	--enable-elf-shlibs \
	--disable-debugfs \
	--disable-imager \
	--disable-resizer \
	--enable-fsck \
	--disable-e2initrd-helper \
	--disable-testio-debug

E2FSPROGS_MAKE_OPT = \
	LDCONFIG=true

define HOST_E2FSPROGS_INSTALL_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D) install install-libs
endef

# binaries to keep or remove
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_BADBLOCKS) += usr/sbin/badblocks
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_BLKID) += usr/sbin/blkid
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_CHATTR) += usr/bin/chattr
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_DUMPE2FS) += usr/sbin/dumpe2fs
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2FREEFRAG) += usr/sbin/e2freefrag
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2FSCK) += usr/sbin/e2fsck
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2LABEL) += usr/sbin/e2label
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_E2UNDO) += usr/sbin/e2undo
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_FILEFRAG) += usr/sbin/filefrag
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_FSCK) += usr/sbin/fsck
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_LOGSAVE) += usr/sbin/logsave
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_LSATTR) += usr/bin/lsattr
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_MKE2FS) += usr/sbin/mke2fs
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_MKLOSTFOUND) += usr/sbin/mklost+found
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_UUIDD) += usr/sbin/uuidd
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_UUIDGEN) += usr/bin/uuidgen

# libraries to keep or remove
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_LIBUUID) += usr/lib/libuuid.so*
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_LIBBLKID) += usr/lib/libblkid.so*
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_UTILS) += usr/lib/libcom_err.so*
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_UTILS) += usr/lib/libe2p.so*
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_UTILS) += usr/lib/libext2fs.so*
E2FSPROGS_BINTARGETS_$(BR2_PACKAGE_E2FSPROGS_UTILS) += usr/lib/libss.so*

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

define E2FSPROGS_STAGING_LIBUUID_INSTALL
	install -D $(@D)/lib/uuid/uuid.h $(STAGING_DIR)/usr/include/uuid/uuid.h
	install -D $(@D)/lib/uuid/uuid.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/uuid.pc
endef

ifeq ($(BR2_PACKAGE_E2FSPROGS_LIBUUID),y)
E2FSPROGS_POST_INSTALL_STAGING_HOOKS += E2FSPROGS_STAGING_LIBUUID_INSTALL
endif

define E2FSPROGS_STAGING_LIBBLKID_INSTALL
	install -D $(@D)/lib/blkid/blkid.h \
		$(STAGING_DIR)/usr/include/blkid/blkid.h
	install -D $(@D)/lib/blkid/blkid_types.h \
		$(STAGING_DIR)/usr/include/blkid/blkid_types.h
	install -D $(@D)/lib/blkid/blkid.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/blkid.pc
endef

ifeq ($(BR2_PACKAGE_E2FSPROGS_LIBBLKID),y)
E2FSPROGS_POST_INSTALL_STAGING_HOOKS += E2FSPROGS_STAGING_LIBBLKID_INSTALL
endif

$(eval $(call AUTOTARGETS,package,e2fsprogs))
$(eval $(call AUTOTARGETS,package,e2fsprogs,host))
