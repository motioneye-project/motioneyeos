#############################################################
#
# dnsmasq1
#
#############################################################

DNSMASQ1_SOURCE=dnsmasq-1.18.tar.gz
DNSMASQ1_SITE=http://thekelleys.org.uk/dnsmasq
DNSMASQ1_DIR=$(BUILD_DIR)/dnsmasq-1.18
DNSMASQ1_BINARY=dnsmasq
DNSMASQ1_TARGET_BINARY=usr/sbin/dnsmasq

$(DL_DIR)/$(DNSMASQ1_SOURCE):
	$(WGET) -P $(DL_DIR) $(DNSMASQ1_SITE)/$(DNSMASQ1_SOURCE)

$(DNSMASQ1_DIR)/.source: $(DL_DIR)/$(DNSMASQ1_SOURCE)
	zcat $(DL_DIR)/$(DNSMASQ1_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	$(SOURCE_DIR)/patch-kernel.sh $(DNSMASQ1_DIR) $(SOURCE_DIR) dnsmasq1-*.patch
	touch $(DNSMASQ1_DIR)/.source

$(DNSMASQ1_DIR)/$(DNSMASQ1_BINARY): $(DNSMASQ1_DIR)/.source
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" \
		BINDIR=/usr/sbin MANDIR=/usr/man -C $(DNSMASQ1_DIR)

$(TARGET_DIR)/$(DNSMASQ1_TARGET_BINARY): $(DNSMASQ1_DIR)/$(DNSMASQ1_BINARY)
	$(MAKE) BINDIR=/usr/sbin MANDIR=/usr/man \
		DESTDIR=$(TARGET_DIR) -C $(DNSMASQ1_DIR) install
	$(STRIP) $(TARGET_DIR)/$(DNSMASQ1_TARGET_BINARY)
	rm -Rf $(TARGET_DIR)/usr/man

dnsmasq1: uclibc $(TARGET_DIR)/$(DNSMASQ1_TARGET_BINARY)

dnsmasq1-source: $(DL_DIR)/$(DNSMASQ1_SOURCE)

dnsmasq1-clean:
	#$(MAKE) prefix=$(TARGET_DIR)/usr -C $(DNSMASQ1_DIR) uninstall
	-$(MAKE) -C $(DNSMASQ1_DIR) clean

dnsmasq1-dirclean:
	rm -rf $(DNSMASQ1_DIR)

