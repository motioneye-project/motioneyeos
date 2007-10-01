#############################################################
#
# xerces
#
#############################################################
XERCES_VERSION:=2.7.0
XERCES_SOURCE:=xerces-c-src_2_7_0.tar.gz
XERCES_SITE:=http://www.apache.org/dist/xml/xerces-c/source/
XERCES_CAT:=$(ZCAT)
XERCES_DIR:=$(BUILD_DIR)/xerces-c-src_2_7_0
XERCES_BINARY:=lib/libxerces-c.so.27.0

$(DL_DIR)/$(XERCES_SOURCE):
	 $(WGET) -P $(DL_DIR) $(XERCES_SITE)/$(XERCES_SOURCE)

xerces-source: $(DL_DIR)/$(XERCES_SOURCE)

$(XERCES_DIR)/.unpacked: $(DL_DIR)/$(XERCES_SOURCE)
	$(XERCES_CAT) $(DL_DIR)/$(XERCES_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
# toolchain/patch-kernel.sh $(XERCES_DIR) package/xerces/ \*.patch*
	touch $(XERCES_DIR)/.unpacked

$(XERCES_DIR)/.configured: $(XERCES_DIR)/.unpacked
	(cd $(XERCES_DIR)/src/xercesc; rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		XERCESCROOT=$(XERCES_DIR) \
		./runConfigure -plinux -minmem \
		-nsocket -tnative -rpthread \
		-c$(TARGET_CC) -x$(TARGET_CXX) \
	)
	touch $(XERCES_DIR)/.configured

$(XERCES_DIR)/$(XERCES_BINARY): $(XERCES_DIR)/.configured
	$(MAKE) XERCESCROOT=$(XERCES_DIR) -C $(XERCES_DIR)/src/xercesc

$(STAGING_DIR)/$(XERCES_BINARY): $(XERCES_DIR)/$(XERCES_BINARY)
	$(MAKE) XERCESCROOT=$(XERCES_DIR) PREFIX=$(STAGING_DIR) \
		-C $(XERCES_DIR)/src/xercesc install

$(TARGET_DIR)/usr/$(XERCES_BINARY): $(STAGING_DIR)/$(XERCES_BINARY)
	cp -a $(STAGING_DIR)/lib/libxerces-c.so* $(TARGET_DIR)/usr/lib
	cp -a $(STAGING_DIR)/lib/libxerces-depdom.so* $(TARGET_DIR)/usr/lib
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libxerces-c.so.27.0
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libxerces-depdom.so.27.0

xerces: uclibc $(TARGET_DIR)/usr/$(XERCES_BINARY)

xerces-clean:
	rm -rf $(STAGING_DIR)/usr/include/xercesc
	rm -f $(STAGING_DIR)/lib/libxerces*
	rm -f $(TARGET_DIR)/usr/lib/libxerces*
	-$(MAKE) -C $(XERCES_DIR) clean

xerces-dirclean:
	rm -rf $(XERCES_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_XERCES)),y)
TARGETS+=xerces
endif
