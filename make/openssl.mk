#############################################################
#
# openssl
#
#############################################################

# TARGETS
OPENSSL_SITE:=http://www.openssl.org/source
OPENSSL_SOURCE:=openssl-0.9.6g.tar.gz
OPENSSL_DIR:=$(BUILD_DIR)/openssl-0.9.6g


$(DL_DIR)/$(OPENSSL_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENSSL_SITE)/$(OPENSSL_SOURCE)

$(OPENSSL_DIR)/.unpacked: $(DL_DIR)/$(OPENSSL_SOURCE)
	gunzip -c $(DL_DIR)/$(OPENSSL_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch  $(OPENSSL_DIR)/.unpacked

$(OPENSSL_DIR)/Makefile: $(OPENSSL_DIR)/.unpacked
	(cd $(OPENSSL_DIR); \
	PATH=$(TARGET_PATH) ./Configure linux-elf --prefix=$(STAGING_DIR) \
		--openssldir=$(STAGING_DIR) -L$(STAGING_DIR)/lib -ldl \
		-I$(STAGING_DIR)/include no-threads shared no-asm)

$(OPENSSL_DIR)/apps/openssl: $(OPENSSL_DIR)/Makefile
	make CC=$(TARGET_CC1) -C $(OPENSSL_DIR)

$(STAGING_DIR)/bin/openssl: $(OPENSSL_DIR)/apps/openssl
	make CC=$(TARGET_CC1) -C $(OPENSSL_DIR) install

$(TARGET_DIR)/bin/openssl: $(STAGING_DIR)/bin/openssl
	cp -fa $(STAGING_DIR)/lib/libcrypto.so* $(TARGET_DIR)/lib/
	cp -fa $(STAGING_DIR)/lib/libssl.so* $(TARGET_DIR)/lib/
	#cp -fa $(STAGING_DIR)/bin/openssl  $(TARGET_DIR)/bin/

openssl-clean: 
	rm -f $(STAGING_DIR)/bin/openssl  $(TARGET_DIR)/bin/openssl
	rm -f $(STAGING_DIR)/lib/libcrypto.so* $(TARGET_DIR)/lib/libcrypto.so*
	rm -f $(STAGING_DIR)/lib/libssl.so* $(TARGET_DIR)/lib/libssl.so*
	$(MAKE) -C $(OPENSSL_DIR) clean

openssl-dirclean: 
	rm -rf $(OPENSSL_DIR) 

openssl: uclibc $(TARGET_DIR)/bin/openssl

#EOF

