#############################################################
#
# netkittelnet
#
#############################################################
NETKITTELNET_VERSION:=0.17
NETKITTELNET_SOURCE:=netkit-telnet-$(NETKITTELNET_VERSION).tar.gz
NETKITTELNET_SITE:=ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/
NETKITTELNET_DIR:=$(BUILD_DIR)/netkit-telnet-$(NETKITTELNET_VERSION)
NETKITTELNET_CAT:=$(ZCAT)
NETKITTELNET_BINARY:=telnetd/telnetd
NETKITTELNET_TARGET_BINARY:=usr/sbin/telnetd

$(DL_DIR)/$(NETKITTELNET_SOURCE):
	 $(call DOWNLOAD,$(NETKITTELNET_SITE)/$(NETKITTELNET_SOURCE))

netkittelnet-source: $(DL_DIR)/$(NETKITTELNET_SOURCE)

$(NETKITTELNET_DIR)/.unpacked: $(DL_DIR)/$(NETKITTELNET_SOURCE)
	$(NETKITTELNET_CAT) $(DL_DIR)/$(NETKITTELNET_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	# use ANSI syntax
	$(SED) "s/main()/main(void)/;" $(NETKITTELNET_DIR)/configure
	# Disable termcap support
	$(SED) "s~\(.*termcap\.h.*\)~/* \1 */~;" $(NETKITTELNET_DIR)/telnetd/telnetd.c
	# don't try to run cross compiled binaries while configuring things
	support/scripts/apply-patches.sh $(NETKITTELNET_DIR) package/netkittelnet/ netkittelnet\*.patch
	touch $(NETKITTELNET_DIR)/.unpacked

$(NETKITTELNET_DIR)/.configured: $(NETKITTELNET_DIR)/.unpacked
	(cd $(NETKITTELNET_DIR); rm -f config.cache; \
	 PATH=$(TARGET_PATH) CC="$(TARGET_CC)" \
	./configure --installroot=$(TARGET_DIR) --with-c-compiler="$(TARGET_CC)" \
	)
	touch $(NETKITTELNET_DIR)/.configured

$(NETKITTELNET_DIR)/$(NETKITTELNET_BINARY): $(NETKITTELNET_DIR)/.configured
	$(MAKE) SUB=telnetd CC="$(TARGET_CC)" -C $(NETKITTELNET_DIR)
	$(STRIPCMD) $(NETKITTELNET_DIR)/$(NETKITTELNET_BINARY)

$(TARGET_DIR)/$(NETKITTELNET_TARGET_BINARY): $(NETKITTELNET_DIR)/$(NETKITTELNET_BINARY)
	# Only install a few selected items...
	mkdir -p $(TARGET_DIR)/usr/sbin
	rm -f $(TARGET_DIR)/$(NETKITTELNET_TARGET_BINARY)
	cp $(NETKITTELNET_DIR)/$(NETKITTELNET_BINARY) $(TARGET_DIR)/$(NETKITTELNET_TARGET_BINARY)
	# Enable telnet in inetd
	$(SED) "s~^#telnet.*~telnet\tstream\ttcp\tnowait\troot\t/usr/sbin/telnetd\t/usr/sbin/telnetd~;" $(TARGET_DIR)/etc/inetd.conf
	#$(MAKE) DESTDIR=$(TARGET_DIR) CC="$(TARGET_CC)" -C $(NETKITTELNET_DIR) install
	#rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
	# $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

netkittelnet-legal-info:
	@$(call legal-warning-pkg,netkittelnet,legal-info not yet implemented)

netkittelnet: netkitbase $(TARGET_DIR)/$(NETKITTELNET_TARGET_BINARY)

netkittelnet-clean:
	#$(MAKE) DESTDIR=$(TARGET_DIR) CC="$(TARGET_CC)" -C $(NETKITTELNET_DIR) uninstall
	-rm -f $(TARGET_DIR)/usr/sbin/telnetd
	-$(MAKE) -C $(NETKITTELNET_DIR) clean

netkittelnet-dirclean:
	rm -rf $(NETKITTELNET_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_NETKITTELNET),y)
TARGETS+=netkittelnet
endif
