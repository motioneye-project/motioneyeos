#############################################################
#
# hostap
#
#############################################################
HOSTAP_SOURCE_URL=http://hostap.epitest.fi/cgi-bin/viewcvs.cgi/hostap/hostap.tar.gz?tarball=1
HOSTAP_SOURCE=hostap.tar.gz
HOSTAP_DIR=$(BUILD_DIR)/hostap-snapshot
HOSTAP_TARGET_MODULE_DIR=$(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/hostap

$(DL_DIR)/$(HOSTAP_SOURCE):
	$(WGET) -P $(DL_DIR) $(HOSTAP_SOURCE_URL) -O $(DL_DIR)/$(HOSTAP_SOURCE)

hostap-source: $(DL_DIR)/$(HOSTAP_SOURCE)

$(HOSTAP_DIR)/.unpacked: $(DL_DIR)/$(HOSTAP_SOURCE)
	zcat $(DL_DIR)/$(HOSTAP_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mv -f $(BUILD_DIR)/hostap $(HOSTAP_DIR)
	touch $(HOSTAP_DIR)/.unpacked

$(HOSTAP_DIR)/.configured: $(HOSTAP_DIR)/.unpacked
	perl -pi -e "s,/.*#define PRISM2_DOWNLOAD_SUPPORT.*/,#define PRISM2_DOWNLOAD_SUPPORT,g" \
		$(HOSTAP_DIR)/driver/modules/hostap_config.h
	touch  $(HOSTAP_DIR)/.configured

$(HOSTAP_DIR)/driver/modules/hostap.o: $(HOSTAP_DIR)/.configured
	$(MAKE) -C $(HOSTAP_DIR) pccard KERNEL_PATH=$(LINUX_SOURCE_DIR) CC=$(TARGET_CC)
	$(MAKE) -C $(HOSTAP_DIR) pci KERNEL_PATH=$(LINUX_SOURCE_DIR) CC=$(TARGET_CC)
	$(MAKE) -C $(HOSTAP_DIR) plx KERNEL_PATH=$(LINUX_SOURCE_DIR) CC=$(TARGET_CC)
	$(MAKE) -C $(HOSTAP_DIR)/utils CC=$(TARGET_CC)
	$(MAKE) -C $(HOSTAP_DIR)/hostapd CC=$(TARGET_CC) 
	touch -c $(HOSTAP_DIR)/driver/modules/hostap.o

$(HOSTAP_TARGET_MODULE_DIR)/hostap.o: $(HOSTAP_DIR)/driver/modules/hostap.o
	# Make the dir
	-rm -rf $(HOSTAP_TARGET_MODULE_DIR)
	-mkdir -p $(HOSTAP_TARGET_MODULE_DIR)
	# Copy The Module Files
	cp -af $(HOSTAP_DIR)/driver/modules/*.o $(HOSTAP_TARGET_MODULE_DIR)/
	# Copy the pcmcia-cs conf file
	-mkdir -p $(TARGET_DIR)/etc/pcmcia	
	cp -af $(HOSTAP_DIR)/driver/etc/hostap_cs.conf $(TARGET_DIR)/etc/pcmcia/
	# Copy The Utils
	cp -af $(HOSTAP_DIR)/utils/hostap_crypt_conf $(TARGET_DIR)/usr/bin/
	cp -af $(HOSTAP_DIR)/utils/hostap_diag $(TARGET_DIR)/usr/bin/
	cp -af $(HOSTAP_DIR)/utils/prism2_param $(TARGET_DIR)/usr/bin/
	cp -af $(HOSTAP_DIR)/utils/prism2_srec $(TARGET_DIR)/usr/bin/
	# Copy hostapd
	cp -af $(HOSTAP_DIR)/hostapd/hostapd $(TARGET_DIR)/usr/sbin/
	touch -c $(HOSTAP_TARGET_MODULE_DIR)/hostap.o

# use busybox depmod.pl so we need the sources unpacked
$(HOSTAP_DIR)/.modules.dep: $(BUSYBOX_DIR)/.configured $(TARGET_DIR)/lib/modules
	[ -d $(TARGET_DIR)/lib/modules/$(LINUX_VERSION) ] && \
	$(BUSYBOX_DIR)/examples/depmod.pl \
		-b $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/ \
		-k $(LINUX_DIR)/vmlinux \
		-F $(LINUX_DIR)/System.map \
		> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/modules.dep
	touch $(HOSTAP_DIR)/.modules.dep

hostap: pcmcia $(HOSTAP_TARGET_MODULE_DIR)/hostap.o $(HOSTAP_DIR)/.modules.dep

hostap-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(HOSTAP_DIR) uninstall
	-$(MAKE) -C $(HOSTAP_DIR) clean

hostap-dirclean:
	rm -rf $(HOSTAP_DIR)

