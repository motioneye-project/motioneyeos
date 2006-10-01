#############################################################
#
# hdparm
#
#############################################################
HDPARM_SOURCE:=hdparm-6.5.tar.gz
HDPARM_SITE:=http://www.ibiblio.org/pub/Linux/system/hardware/
HDPARM_CAT:=$(ZCAT)
HDPARM_DIR:=$(BUILD_DIR)/hdparm-6.5
HDPARM_BINARY:=hdparm
HDPARM_TARGET_BINARY:=sbin/hdparm

$(DL_DIR)/$(HDPARM_SOURCE):
	 $(WGET) -P $(DL_DIR) $(HDPARM_SITE)/$(HDPARM_SOURCE)

hdparm-source: $(DL_DIR)/$(HDPARM_SOURCE)

hdparm-unpacked: $(HDPARM_DIR)/.unpacked
$(HDPARM_DIR)/.unpacked: $(DL_DIR)/$(HDPARM_SOURCE)
	$(HDPARM_CAT) $(DL_DIR)/$(HDPARM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(HDPARM_DIR)/.unpacked

$(HDPARM_DIR)/.configured: $(HDPARM_DIR)/.unpacked
	touch $(HDPARM_DIR)/.configured

$(HDPARM_DIR)/$(HDPARM_BINARY): $(HDPARM_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(HDPARM_DIR)

$(TARGET_DIR)/$(HDPARM_TARGET_BINARY): $(HDPARM_DIR)/$(HDPARM_BINARY)
	cp -a $(HDPARM_DIR)/$(HDPARM_BINARY) $(TARGET_DIR)/$(HDPARM_TARGET_BINARY)

hdparm: uclibc $(TARGET_DIR)/$(HDPARM_TARGET_BINARY)

hdparm-clean:
	rm -f $(TARGET_DIR)/$(HDPARM_TARGET_BINARY)
	-$(MAKE) -C $(HDPARM_DIR) clean

hdparm-dirclean:
	rm -rf $(HDPARM_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_HDPARM)),y)
TARGETS+=hdparm
endif
