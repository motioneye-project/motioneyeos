#############################################################
#
# rsync
#
#############################################################
RSYNC_VER:=2.6.9
RSYNC_SOURCE:=rsync-$(RSYNC_VER).tar.gz
RSYNC_SITE:=http://rsync.samba.org/ftp/rsync/
RSYNC_DIR:=$(BUILD_DIR)/rsync-$(RSYNC_VER)
RSYNC_CAT:=$(ZCAT)
RSYNC_BINARY:=rsync
RSYNC_TARGET_BINARY:=usr/bin/rsync

$(DL_DIR)/$(RSYNC_SOURCE):
	$(WGET) -P $(DL_DIR) $(RSYNC_SITE)/$(RSYNC_SOURCE)

$(RSYNC_DIR)/.unpacked: $(DL_DIR)/$(RSYNC_SOURCE)
	$(RSYNC_CAT) $(DL_DIR)/$(RSYNC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(RSYNC_DIR) package/rsync/ rsync\*.patch
	touch $(RSYNC_DIR)/.unpacked

$(RSYNC_DIR)/.configured: $(RSYNC_DIR)/.unpacked
	(cd $(RSYNC_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) CC_FOR_BUILD="$(HOSTCC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--with-included-popt \
	);
	touch $(RSYNC_DIR)/.configured

$(RSYNC_DIR)/$(RSYNC_BINARY): $(RSYNC_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(RSYNC_DIR)

$(TARGET_DIR)/$(RSYNC_TARGET_BINARY): $(RSYNC_DIR)/$(RSYNC_BINARY)
	install -D $(RSYNC_DIR)/$(RSYNC_BINARY) $(TARGET_DIR)/$(RSYNC_TARGET_BINARY)

rsync: uclibc $(TARGET_DIR)/$(RSYNC_TARGET_BINARY)

rsync-clean:
	rm -f $(TARGET_DIR)/$(RSYNC_TARGET_BINARY)
	-$(MAKE) -C $(RSYNC_DIR) clean

rsync-dirclean:
	rm -rf $(RSYNC_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_RSYNC)),y)
TARGETS+=rsync
endif
