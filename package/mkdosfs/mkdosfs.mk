#############################################################
#
# mkdosfs
#
#############################################################
MKDOSFS_VERSION:=2.11
MKDOSFS_SOURCE:=dosfstools-$(MKDOSFS_VERSION).src.tar.gz
MKDOSFS_SITE:=http://ftp.uni-erlangen.de/pub/Linux/LOCAL/dosfstools
MKDOSFS_DIR:=$(BUILD_DIR)/dosfstools-$(MKDOSFS_VERSION)
MKDOSFS_CAT:=$(ZCAT)
MKDOSFS_BINARY:=mkdosfs/mkdosfs
MKDOSFS_TARGET_BINARY:=sbin/mkdosfs

$(DL_DIR)/$(MKDOSFS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(MKDOSFS_SITE)/$(MKDOSFS_SOURCE)

mkdosfs-source: $(DL_DIR)/$(MKDOSFS_SOURCE)

$(MKDOSFS_DIR)/.unpacked: $(DL_DIR)/$(MKDOSFS_SOURCE)
	$(MKDOSFS_CAT) $(DL_DIR)/$(MKDOSFS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(MKDOSFS_DIR)/.unpacked

$(MKDOSFS_DIR)/$(MKDOSFS_BINARY): $(MKDOSFS_DIR)/.unpacked
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" CC="$(TARGET_CC)" -C $(MKDOSFS_DIR)
	$(STRIPCMD) $(MKDOSFS_DIR)/mkdosfs/mkdosfs
	touch -c $(MKDOSFS_DIR)/mkdosfs/mkdosfs

$(TARGET_DIR)/$(MKDOSFS_TARGET_BINARY): $(MKDOSFS_DIR)/$(MKDOSFS_BINARY)
	cp -a $(MKDOSFS_DIR)/$(MKDOSFS_BINARY) $@
	touch -c $@

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
