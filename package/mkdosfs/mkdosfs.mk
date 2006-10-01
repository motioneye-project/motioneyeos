#############################################################
#
# mkdosfs
#
#############################################################
MKDOSFS_VER:=2.11
MKDOSFS_SOURCE:=dosfstools-$(MKDOSFS_VER).src.tar.gz
MKDOSFS_SITE:=http://ftp.uni-erlangen.de/pub/Linux/LOCAL/dosfstools
MKDOSFS_DIR:=$(BUILD_DIR)/dosfstools-$(MKDOSFS_VER)
MKDOSFS_CAT:=$(ZCAT)
MKDOSFS_BINARY:=mkdosfs/mkdosfs
MKDOSFS_TARGET_BINARY:=sbin/mkdosfs

MKDOSFS_CFLAGS=$(TARGET_CFLAGS)
ifeq ($(BR2_LARGEFILE),y)
MKDOSFS_CFLAGS+= -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
endif

$(DL_DIR)/$(MKDOSFS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(MKDOSFS_SITE)/$(MKDOSFS_SOURCE)

mkdosfs-source: $(DL_DIR)/$(MKDOSFS_SOURCE)

$(MKDOSFS_DIR)/.unpacked: $(DL_DIR)/$(MKDOSFS_SOURCE)
	$(MKDOSFS_CAT) $(DL_DIR)/$(MKDOSFS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MKDOSFS_DIR)/.unpacked

$(MKDOSFS_DIR)/$(MKDOSFS_BINARY): $(MKDOSFS_DIR)/.unpacked
	$(MAKE) CFLAGS="$(MKDOSFS_CFLAGS)" CC="$(TARGET_CC)" -C $(MKDOSFS_DIR);
	$(STRIP) $(MKDOSFS_DIR)/mkdosfs/mkdosfs
	touch -c $(MKDOSFS_DIR)/mkdosfs/mkdosfs

$(TARGET_DIR)/$(MKDOSFS_TARGET_BINARY): $(MKDOSFS_DIR)/$(MKDOSFS_BINARY)
	cp -a $(MKDOSFS_DIR)/$(MKDOSFS_BINARY) $(TARGET_DIR)/$(MKDOSFS_TARGET_BINARY)
	touch -c $(TARGET_DIR)/sbin/mkdosfs

mkdosfs: uclibc $(TARGET_DIR)/$(MKDOSFS_TARGET_BINARY)

mkdosfs-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(MKDOSFS_DIR) uninstall
	-$(MAKE) -C $(MKDOSFS_DIR) clean

mkdosfs-dirclean:
	rm -rf $(MKDOSFS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MKDOSFS)),y)
TARGETS+=mkdosfs
endif
