#############################################################
#
# STLport standard C++ library
#
#############################################################

STLPORT_DIR=$(BUILD_DIR)/STLport-4.5.3
STLPORT_SITE=http://www.stlport.org/archive
STLPORT_SOURCE=STLport-4.5.3.tar.gz
STLPORT_PATCH=$(SOURCE_DIR)/STLport-4.5.3.patch

$(DL_DIR)/$(STLPORT_SOURCE):
	$(WGET) -P $(DL_DIR) $(STLPORT_SITE)/$(STLPORT_SOURCE)

stlport-source: $(DL_DIR)/$(STLPORT_SOURCE) $(STLPORT_PATCH)

$(STLPORT_DIR)/.configured: $(DL_DIR)/$(STLPORT_SOURCE) $(STLPORT_PATCH)
	zcat $(DL_DIR)/$(STLPORT_SOURCE) | tar -C $(BUILD_DIR) -xvf - 
	cat $(STLPORT_PATCH) | patch -d $(STLPORT_DIR) -p1
	touch -c $(STLPORT_DIR)/.configured

$(STLPORT_DIR)/lib/libstdc++.so.4.5: $(STLPORT_DIR)/.configured
	$(MAKE) ARCH=$(ARCH) PREFIX=$(STAGING_DIR) -C $(STLPORT_DIR)

$(STAGING_DIR)/lib/libstdc++.so.4.5: $(STLPORT_DIR)/lib/libstdc++.so.4.5
	$(MAKE) ARCH=$(ARCH) PREFIX=$(STAGING_DIR) -C $(STLPORT_DIR) install

$(TARGET_DIR)/lib/libstdc++.so.4.5: $(STAGING_DIR)/lib/libstdc++.so.4.5
	cp -dpf $(STAGING_DIR)/lib/libstdc++.so* $(TARGET_DIR)/lib/

stlport: $(TARGET_DIR)/lib/libstdc++.so.4.5

stlport-clean:
	rm -f $(TARGET_DIR)/lib/libstdc++*
	-$(MAKE) -C $(STLPORT_DIR) clean

stlport-dirclean:
	rm -rf $(STLPORT_DIR)
