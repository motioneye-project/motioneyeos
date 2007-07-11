#############################################################
#
# e2fsprogs
#
#############################################################
E2FSPROGS_VERSION:=1.39
E2FSPROGS_SOURCE=e2fsprogs-$(E2FSPROGS_VERSION).tar.gz
E2FSPROGS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/e2fsprogs
E2FSPROGS_DIR=$(BUILD_DIR)/e2fsprogs-$(E2FSPROGS_VERSION)
E2FSPROGS_CAT:=$(ZCAT)
E2FSPROGS_BINARY:=misc/mke2fs
E2FSPROGS_TARGET_BINARY:=sbin/mke2fs

E2FSPROGS_MISC_STRIP:= \
	badblocks blkid chattr dumpe2fs filefrag fsck logsave \
	lsattr mke2fs mklost+found tune2fs uuidgen

$(DL_DIR)/$(E2FSPROGS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(E2FSPROGS_SITE)/$(E2FSPROGS_SOURCE)

e2fsprogs-source: $(DL_DIR)/$(E2FSPROGS_SOURCE)

$(E2FSPROGS_DIR)/.unpacked: $(DL_DIR)/$(E2FSPROGS_SOURCE)
	$(E2FSPROGS_CAT) $(DL_DIR)/$(E2FSPROGS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(E2FSPROGS_DIR) package/e2fsprogs/ e2fsprogs\*.patch
	$(CONFIG_UPDATE) $(E2FSPROGS_DIR)/config
	touch $@

$(E2FSPROGS_DIR)/.configured: $(E2FSPROGS_DIR)/.unpacked
	(cd $(E2FSPROGS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--with-cc=$(TARGET_CC) \
		--with-linker=$(TARGET_CROSS)ld \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/bin \
		--sbindir=/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-elf-shlibs --enable-dynamic-e2fsck --disable-swapfs \
		--disable-debugfs --disable-imager \
		--disable-resizer --enable-fsck \
		--disable-e2initrd-helper \
		--without-catgets $(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	);
	touch $@

$(E2FSPROGS_DIR)/$(E2FSPROGS_BINARY): $(E2FSPROGS_DIR)/.configured
	$(MAKE1) PATH=$(TARGET_PATH) -C $(E2FSPROGS_DIR)
	( \
		cd $(E2FSPROGS_DIR)/misc ; \
		$(STRIP) $(E2FSPROGS_MISC_STRIP) ; \
	)
	$(STRIP) $(E2FSPROGS_DIR)/lib/lib*.so.*.*
	touch -c $(E2FSPROGS_DIR)/$(E2FSPROGS_BINARY)

$(TARGET_DIR)/$(E2FSPROGS_TARGET_BINARY): $(E2FSPROGS_DIR)/$(E2FSPROGS_BINARY)
	$(MAKE1) PATH=$(TARGET_PATH) DESTDIR=$(TARGET_DIR) -C $(E2FSPROGS_DIR) install
	rm -rf ${TARGET_DIR}/sbin/mkfs.ext[23] ${TARGET_DIR}/sbin/fsck.ext[23] \
		${TARGET_DIR}/sbin/findfs ${TARGET_DIR}/sbin/tune2fs
	ln -sf mke2fs ${TARGET_DIR}/sbin/mkfs.ext2
	ln -sf mke2fs ${TARGET_DIR}/sbin/mkfs.ext3
	ln -sf e2fsck ${TARGET_DIR}/sbin/fsck.ext2
	ln -sf e2fsck ${TARGET_DIR}/sbin/fsck.ext3
	ln -sf e2label ${TARGET_DIR}/sbin/tune2fs
	ln -sf e2label ${TARGET_DIR}/sbin/findfs
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	touch -c $(TARGET_DIR)/$(E2FSPROGS_TARGET_BINARY)

e2fsprogs: uclibc $(TARGET_DIR)/$(E2FSPROGS_TARGET_BINARY)

e2fsprogs-clean:
	$(MAKE1) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(E2FSPROGS_DIR) uninstall
	-$(MAKE1) -C $(E2FSPROGS_DIR) clean

e2fsprogs-dirclean:
	rm -rf $(E2FSPROGS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_E2FSPROGS)),y)
TARGETS+=e2fsprogs
endif

