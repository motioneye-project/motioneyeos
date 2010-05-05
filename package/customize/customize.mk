#############################################################
#
# Any custom stuff you feel like doing....
#
#############################################################
CUST_DIR:=package/customize/source

$(BUILD_DIR)/.customize:
	rm -f $(BUILD_DIR)/series
	(cd $(CUST_DIR); \
	 /bin/ls -d * > $(BUILD_DIR)/series || \
	 touch $(BUILD_DIR)/series )
	for f in `cat $(BUILD_DIR)/series`; do \
		cp -af $(CUST_DIR)/$$f $(TARGET_DIR); \
	done
	rm -f $(BUILD_DIR)/series
	touch $@

customize: $(BUILD_DIR)/.customize

customize-clean:
	rm -f $(BUILD_DIR)/.customize

.PHONY: customize
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_CUSTOMIZE),y)
TARGETS+=customize
endif
