#############################################################
#
# openssl
#
#############################################################

# TARGETS
OPENSSL_SITE:=http://www.openssl.org/source
OPENSSL_SOURCE:=openssl-0.9.6g.tar.gz
OPENSSL_DIR:=$(BUILD_DIR)/openssl-0.9.6g
OPENSSL_PATCH=$(SOURCE_DIR)/openssl.patch

$(DL_DIR)/$(OPENSSL_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENSSL_SITE)/$(OPENSSL_SOURCE)

$(OPENSSL_DIR)/.unpacked: $(DL_DIR)/$(OPENSSL_SOURCE) $(OPENSSL_PATCH)
	gunzip -c $(DL_DIR)/$(OPENSSL_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(OPENSSL_PATCH) | patch -p1 -d $(OPENSSL_DIR)
	touch  $(OPENSSL_DIR)/.unpacked

$(OPENSSL_DIR)/Makefile: $(OPENSSL_DIR)/.unpacked
	(cd $(OPENSSL_DIR); \
	PATH=$(TARGET_PATH) ./Configure linux-$(ARCH) --prefix=$(STAGING_DIR) \
		--openssldir=$(STAGING_DIR) -L$(STAGING_DIR)/lib -ldl \
		-I$(STAGING_DIR)/include $(OPENSSL_OPTS) no-threads \
		shared no-idea no-mdc2 no-rc5)

$(OPENSSL_DIR)/apps/openssl: $(OPENSSL_DIR)/Makefile
	make CC=$(TARGET_CC1) -C $(OPENSSL_DIR) all build-shared

$(STAGING_DIR)/lib/libcrypto.so.0: $(OPENSSL_DIR)/apps/openssl
	make CC=$(TARGET_CC1) -C $(OPENSSL_DIR) install
	cp -fa $(OPENSSL_DIR)/libcrypto.so* $(STAGING_DIR)/lib/
	(cd $(STAGING_DIR)/lib; ln -fs libcrypto.so.0.9.6 libcrypto.so)
	(cd $(STAGING_DIR)/lib; ln -fs libcrypto.so.0.9.6 libcrypto.so.0)
	cp -fa $(OPENSSL_DIR)/libssl.so* $(STAGING_DIR)/lib/
	(cd $(STAGING_DIR)/lib; ln -fs libssl.so.0.9.6 libssl.so)
	(cd $(STAGING_DIR)/lib; ln -fs libssl.so.0.9.6 libssl.so.0)

$(TARGET_DIR)/lib/libcrypto.so.0: $(STAGING_DIR)/lib/libcrypto.so.0
	cp -fa $(STAGING_DIR)/lib/libcrypto.so* $(TARGET_DIR)/lib/
	cp -fa $(STAGING_DIR)/lib/libssl.so* $(TARGET_DIR)/lib/
	#cp -fa $(STAGING_DIR)/bin/openssl  $(TARGET_DIR)/bin/

$(TARGET_DIR)/usr/include/openssl/crypto.h: $(TARGET_DIR)/lib/libcrypto.so.0
	mkdir -p $(TARGET_DIR)/usr/include 
	cp -a $(STAGING_DIR)/include/openssl $(TARGET_DIR)/usr/include/
	cp -dpf $(STAGING_DIR)/lib/libssl.a $(TARGET_DIR)/usr/lib/
	cp -dpf $(STAGING_DIR)/lib/libcrypto.a $(TARGET_DIR)/usr/lib/
	touch -c $(TARGET_DIR)/usr/include/openssl/crypto.h

openssl-headers: $(TARGET_DIR)/usr/include/openssl/crypto.h

openssl-clean: 
	rm -f $(STAGING_DIR)/bin/openssl  $(TARGET_DIR)/bin/openssl
	rm -f $(STAGING_DIR)/lib/libcrypto.so* $(TARGET_DIR)/lib/libcrypto.so*
	rm -f $(STAGING_DIR)/lib/libssl.so* $(TARGET_DIR)/lib/libssl.so*
	$(MAKE) -C $(OPENSSL_DIR) clean

openssl-dirclean: 
	rm -rf $(OPENSSL_DIR) 

openssl: uclibc $(TARGET_DIR)/lib/libcrypto.so.0

