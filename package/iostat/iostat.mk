#############################################################
#
# iostat
#
#############################################################
IOSTAT_VERSION:=2.2
IOSTAT_SOURCE:=iostat-$(IOSTAT_VERSION).tar.gz
IOSTAT_SITE:=http://linux.inet.hr/files
IOSTAT_DIR:=$(BUILD_DIR)/iostat-$(IOSTAT_VERSION)
IOSTAT_BINARY:=iostat
IOSTAT_TARGET_BINARY:=usr/bin/iostat

$(DL_DIR)/$(IOSTAT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(IOSTAT_SITE)/$(IOSTAT_SOURCE)

iostat-source: $(DL_DIR)/$(IOSTAT_SOURCE)

$(IOSTAT_DIR)/.unpacked: $(DL_DIR)/$(IOSTAT_SOURCE)
	$(ZCAT) $(DL_DIR)/$(IOSTAT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(IOSTAT_DIR) package/iostat/ iostat\*.patch
	touch $(IOSTAT_DIR)/.unpacked

$(IOSTAT_DIR)/$(IOSTAT_BINARY): $(IOSTAT_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) -C $(IOSTAT_DIR)
	$(STRIPCMD) $(IOSTAT_DIR)/$(IOSTAT_BINARY)

$(TARGET_DIR)/$(IOSTAT_TARGET_BINARY): $(IOSTAT_DIR)/$(IOSTAT_BINARY)
	$(INSTALL) -m 0755 -D $(IOSTAT_DIR)/$(IOSTAT_BINARY) $(TARGET_DIR)/$(IOSTAT_TARGET_BINARY)

iostat: uclibc $(TARGET_DIR)/$(IOSTAT_TARGET_BINARY)

iostat-clean:
	rm -f $(TARGET_DIR)/$(IOSTAT_TARGET_BINARY)
	-$(MAKE) -C $(IOSTAT_DIR) clean

iostat-dirclean:
	rm -rf $(IOSTAT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_IOSTAT),y)
TARGETS+=iostat
endif
