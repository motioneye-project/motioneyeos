#############################################################
#
# wtools - Wireless Tools
#
#############################################################

# This Makefile only work with the multicall version of Wireless Tools,
# which is available in 28-pre3 and later...
# Jean II
# v28.pre3 -> earliest possible
WTOOLS_VER:=28
WTOOLS_SUBVER:=.pre3

WTOOLS_SOURCE_URL:=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux
WTOOLS_SOURCE:=wireless_tools.$(WTOOLS_VER)$(WTOOLS_SUBVER).tar.gz
WTOOLS_BUILD_DIR=$(BUILD_DIR)/wireless_tools.$(WTOOLS_VER)

$(DL_DIR)/$(WTOOLS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(WTOOLS_SOURCE_URL)/$(WTOOLS_SOURCE) 

$(WTOOLS_BUILD_DIR)/.unpacked: $(DL_DIR)/$(WTOOLS_SOURCE)
	zcat $(DL_DIR)/$(WTOOLS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	sed -i -e s:'strip':'$(STRIP)':g $(WTOOLS_BUILD_DIR)/Makefile
	touch $(WTOOLS_BUILD_DIR)/.unpacked

$(WTOOLS_BUILD_DIR)/.configured: $(WTOOLS_BUILD_DIR)/.unpacked
	touch  $(WTOOLS_BUILD_DIR)/.configured

$(WTOOLS_BUILD_DIR)/iwmulticall: $(WTOOLS_BUILD_DIR)/.configured
	$(MAKE) -C $(WTOOLS_BUILD_DIR) \
		CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" \
		iwmulticall

$(TARGET_DIR)/sbin/iwconfig: $(WTOOLS_BUILD_DIR)/iwmulticall
	$(MAKE) -C $(WTOOLS_BUILD_DIR) \
		PREFIX="$(TARGET_DIR)" \
		CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" \
		install-iwmulticall

wtools: $(TARGET_DIR)/sbin/iwconfig 

wtools-source: $(DL_DIR)/$(WTOOLS_SOURCE)

wtools-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(WTOOLS_BUILD_DIR) uninstall
	-$(MAKE) -C $(WTOOLS_BUILD_DIR) clean

wtools-dirclean:
	rm -rf $(WTOOLS_BUILD_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_WTOOLS)),y)
TARGETS+=wtools
endif
