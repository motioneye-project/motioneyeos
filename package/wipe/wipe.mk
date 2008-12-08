#############################################################
#
# wipe
#
# http://abaababa.ouvaton.org/wipe/wipe-$(WIPE_VERSION).tar.gz
#############################################################
WIPE_VERSION:=0.20
WIPE_SOURCE:=wipe-$(WIPE_VERSION).tar.gz
#WIPE_PATCH:=wipe_0.2-19.diff.gz
WIPE_SITE:=http://abaababa.ouvaton.org/wipe
WIPE_CAT:=$(ZCAT)
WIPE_DIR:=$(BUILD_DIR)/wipe-$(WIPE_VERSION)
WIPE_BINARY:=wipe
WIPE_TARGET_BINARY:=bin/wipe

$(DL_DIR)/$(WIPE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(WIPE_SITE)/$(WIPE_SOURCE)

ifneq ($(WIPE_PATCH),)
$(DL_DIR)/$(WIPE_PATCH):
	 $(WGET) -P $(DL_DIR) $(WIPE_SITE)/$(WIPE_PATCH)
endif

wipe-source: $(DL_DIR)/$(WIPE_SOURCE) $(DL_DIR)/$(WIPE_PATCH)

$(WIPE_DIR)/.unpacked: $(DL_DIR)/$(WIPE_SOURCE) $(DL_DIR)/$(WIPE_PATCH)
	$(WIPE_CAT) $(DL_DIR)/$(WIPE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	#toolchain/patch-kernel.sh $(WIPE_DIR) $(DL_DIR) $(WIPE_PATCH)
	touch $(WIPE_DIR)/.unpacked

$(WIPE_DIR)/.configured: $(WIPE_DIR)/.unpacked
	touch $@

$(WIPE_DIR)/$(WIPE_BINARY): $(WIPE_DIR)/.configured
	rm -f $(WIPE_DIR)/$(WIPE_BINARY)
	$(MAKE) CC=$(TARGET_CC) CC_GENERIC=$(TARGET_CC) -C $(WIPE_DIR) generic

$(TARGET_DIR)/$(WIPE_TARGET_BINARY): $(WIPE_DIR)/$(WIPE_BINARY)
	cp -a $(WIPE_DIR)/$(WIPE_BINARY) $(TARGET_DIR)/$(WIPE_TARGET_BINARY)

wipe: uclibc $(TARGET_DIR)/$(WIPE_TARGET_BINARY)

wipe-clean:
	#$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(WIPE_DIR) uninstall
	-$(MAKE) -C $(WIPE_DIR) clean

wipe-dirclean:
	rm -rf $(WIPE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_WIPE),y)
TARGETS+=wipe
endif
