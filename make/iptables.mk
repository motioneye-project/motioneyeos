#############################################################
#
# iptables
#
#############################################################
IPTABLES_SOURCE_URL=http://www.netfilter.org/files
IPTABLES_SOURCE=iptables-1.2.8.tar.bz2
IPTABLES_BUILD_DIR=$(BUILD_DIR)/iptables-1.2.8

$(DL_DIR)/$(IPTABLES_SOURCE):
	 $(WGET) -P $(DL_DIR) $(IPTABLES_SOURCE_URL)/$(IPTABLES_SOURCE) 

$(IPTABLES_BUILD_DIR)/.unpacked: $(DL_DIR)/$(IPTABLES_SOURCE)
	bzcat $(DL_DIR)/$(IPTABLES_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(IPTABLES_BUILD_DIR)/.unpacked

$(IPTABLES_BUILD_DIR)/.configured: $(IPTABLES_BUILD_DIR)/.unpacked
	$(SED) "s;\[ -f /usr/include/netinet/ip6.h \];grep -q '__UCLIBC_HAS_IPV6__ 1' \
		$(BUILD_DIR)/uClibc/include/bits/uClibc_config.h;" $(IPTABLES_BUILD_DIR)/Makefile
	touch  $(IPTABLES_BUILD_DIR)/.configured

$(IPTABLES_BUILD_DIR)/iptables: $(IPTABLES_BUILD_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) -C $(IPTABLES_BUILD_DIR) KERNEL_DIR=$(BUILD_DIR)/linux CC=$(TARGET_CC)

$(TARGET_DIR)/sbin/iptables: $(IPTABLES_BUILD_DIR)/iptables
	# Copy iptables 
	cp -af $(IPTABLES_BUILD_DIR)/iptables $(TARGET_DIR)/sbin/
	cp -af $(IPTABLES_BUILD_DIR)/iptables-save $(TARGET_DIR)/sbin/
	cp -af $(IPTABLES_BUILD_DIR)/iptables-restore $(TARGET_DIR)/sbin/
	-mkdir -p $(TARGET_DIR)/usr/local/lib/iptables
	cp -af $(IPTABLES_BUILD_DIR)/extensions/*.so $(TARGET_DIR)/usr/local/lib/iptables/

iptables: $(TARGET_DIR)/sbin/iptables 

iptables-source: $(DL_DIR)/$(IPTABLES_SOURCE)

iptables-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(IPTABLES_BUILD_DIR) uninstall
	-$(MAKE) -C $(IPTABLES_BUILD_DIR) clean

iptables-dirclean:
	rm -rf $(IPTABLES_BUILD_DIR)

