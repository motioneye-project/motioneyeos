#############################################################
#
# wtools - Wireless Tools
#
#############################################################
#
WTOOLS_SOURCE_URL=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux
WTOOLS_SOURCE=wireless_tools.26.tar.gz
WTOOLS_BUILD_DIR=$(BUILD_DIR)/wireless_tools.26

$(DL_DIR)/$(WTOOLS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(WTOOLS_SOURCE_URL)/$(WTOOLS_SOURCE) 

$(WTOOLS_BUILD_DIR)/.unpacked: $(DL_DIR)/$(WTOOLS_SOURCE)
	zcat $(DL_DIR)/$(WTOOLS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(WTOOLS_BUILD_DIR)/.unpacked

$(WTOOLS_BUILD_DIR)/.configured: $(WTOOLS_BUILD_DIR)/.unpacked
	touch  $(WTOOLS_BUILD_DIR)/.configured

$(WTOOLS_BUILD_DIR)/iwconfig: $(WTOOLS_BUILD_DIR)/.configured
	$(MAKE) -C $(WTOOLS_BUILD_DIR) KERNEL_SRC=$(BUILD_DIR)/linux CC=$(TARGET_CC)

$(TARGET_DIR)/sbin/iwconfig: $(WTOOLS_BUILD_DIR)/iwconfig
	# Copy The Wireless Tools
	cp -af $(WTOOLS_BUILD_DIR)/iwconfig $(TARGET_DIR)/sbin/
	cp -af $(WTOOLS_BUILD_DIR)/iwevent $(TARGET_DIR)/sbin/
	cp -af $(WTOOLS_BUILD_DIR)/iwgetid $(TARGET_DIR)/sbin/
	cp -af $(WTOOLS_BUILD_DIR)/iwlist $(TARGET_DIR)/sbin/
	cp -af $(WTOOLS_BUILD_DIR)/iwpriv $(TARGET_DIR)/sbin/
	cp -af $(WTOOLS_BUILD_DIR)/iwspy $(TARGET_DIR)/sbin/

wtools: $(TARGET_DIR)/sbin/iwconfig 

wtools-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(WTOOLS_BUILD_DIR) uninstall
	-$(MAKE) -C $(WTOOLS_BUILD_DIR) clean

wtools-dirclean:
	rm -rf $(WTOOLS_BUILD_DIR)

