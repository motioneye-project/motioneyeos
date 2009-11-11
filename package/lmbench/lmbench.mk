#############################################################
#
# lmbench
#
#############################################################
LMBENCH_VERSION:=3.0-a9
LMBENCH_SOURCE:=lmbench-$(LMBENCH_VERSION).tgz
LMBENCH_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/lmbench/development/lmbench-3.0-a9/
LMBENCH_CAT:=$(ZCAT)
LMBENCH_DIR:=$(BUILD_DIR)/lmbench-$(LMBENCH_VERSION)
LMBENCH_BIN:=lmbench
LMBENCH_TARGET_BIN:=usr/bin/$(LMBENCH_BIN)

$(DL_DIR)/$(LMBENCH_SOURCE):
	$(call DOWNLOAD,$(LMBENCH_SITE),$(LMBENCH_SOURCE))

$(LMBENCH_DIR)/.unpacked: $(DL_DIR)/$(LMBENCH_SOURCE)
	$(LMBENCH_CAT) $(DL_DIR)/$(LMBENCH_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LMBENCH_DIR) package/lmbench lmbench-$(LMBENCH_VERSION)\*.patch
	$(CONFIG_UPDATE) $(LMBENCH_DIR)
	sed -i 's/CFLAGS=/CFLAGS+=/g' $(LMBENCH_DIR)/src/Makefile
	touch $@

$(LMBENCH_DIR)/bin/$(ARCH)/$(LMBENCH_BIN): $(LMBENCH_DIR)/.unpacked
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" OS=$(ARCH) CC=$(TARGET_CC) -C $(LMBENCH_DIR)/src

$(TARGET_DIR)/$(LMBENCH_TARGET_BIN): $(LMBENCH_DIR)/bin/$(ARCH)/$(LMBENCH_BIN)
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" OS=$(ARCH) CC=$(TARGET_CC) BASE=$(TARGET_DIR)/usr -C $(LMBENCH_DIR)/src install

lmbench: $(TARGET_DIR)/$(LMBENCH_TARGET_BIN)

lmbench-source: $(DL_DIR)/$(LMBENCH_SOURCE)

lmbench-clean:
	-$(MAKE) -C $(LMBENCH_DIR)/src clean

lmbench-dirclean:
	rm -rf $(LMBENCH_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LMBENCH),y)
TARGETS+=lmbench
endif
