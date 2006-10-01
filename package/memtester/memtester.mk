#############################################################
#
# memtester
#
#############################################################
MEMTESTER_VER:=4.0.5
MEMTESTER_SOURCE:=memtester-$(MEMTESTER_VER).tar.gz
MEMTESTER_SITE:=http://pyropus.ca/software/memtester
MEMTESTER_DIR:=$(BUILD_DIR)/memtester-$(MEMTESTER_VER)
MEMTESTER_BINARY:=memtester
MEMTESTER_TARGET_BINARY:=usr/bin/memtester

$(DL_DIR)/$(MEMTESTER_SOURCE):
	 $(WGET) -P $(DL_DIR) $(MEMTESTER_SITE)/$(MEMTESTER_SOURCE)

memtester-source: $(DL_DIR)/$(MEMTESTER_SOURCE)

$(MEMTESTER_DIR)/.unpacked: $(DL_DIR)/$(MEMTESTER_SOURCE)
	$(ZCAT) $(DL_DIR)/$(MEMTESTER_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	#toolchain/patch-kernel.sh $(MEMTESTER_DIR) package/memtester/ memtester\*.patch
	$(SED) "s,cc,$(TARGET_CC)," $(MEMTESTER_DIR)/conf-*
	touch $(MEMTESTER_DIR)/.unpacked

$(MEMTESTER_DIR)/$(MEMTESTER_BINARY): $(MEMTESTER_DIR)/.unpacked
	$(MAKE) -C $(MEMTESTER_DIR)
	$(STRIP) $(MEMTESTER_DIR)/$(MEMTESTER_BINARY)

$(TARGET_DIR)/$(MEMTESTER_TARGET_BINARY): $(MEMTESTER_DIR)/$(MEMTESTER_BINARY)
	$(INSTALL) -m 0755 -D $(MEMTESTER_DIR)/$(MEMTESTER_BINARY) $(TARGET_DIR)/$(MEMTESTER_TARGET_BINARY)

memtester: uclibc $(TARGET_DIR)/$(MEMTESTER_TARGET_BINARY)

memtester-clean:
	rm -f $(TARGET_DIR)/$(MEMTESTER_TARGET_BINARY)
	-$(MAKE) -C $(MEMTESTER_DIR) clean

memtester-dirclean:
	rm -rf $(MEMTESTER_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MEMTESTER)),y)
TARGETS+=memtester
endif
