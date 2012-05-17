#############################################################
#
# ttcp
#
#############################################################
#
TTCP_VERSION:=
TTCP_SOURCE_URL=http://ftp.sunet.se/pub/network/monitoring/ttcp
TTCP_SOURCE=ttcp$(TTCP_VERSION).c
TTCP_DIR=$(BUILD_DIR)/ttcp$(TTCP_VERSION)

$(DL_DIR)/$(TTCP_SOURCE):
	 $(call DOWNLOAD,$(TTCP_SOURCE_URL)/$(TTCP_SOURCE))

$(TTCP_DIR)/.unpacked: $(DL_DIR)/$(TTCP_SOURCE)
	-mkdir $(TTCP_DIR)
	cp -af $(DL_DIR)/$(TTCP_SOURCE) $(TTCP_DIR)
	support/scripts/apply-patches.sh $(TTCP_DIR) package/ttcp/ ttcp-\*.patch
	touch $(TTCP_DIR)/.unpacked

$(TTCP_DIR)/.configured: $(TTCP_DIR)/.unpacked
	touch $(TTCP_DIR)/.configured

$(TTCP_DIR)/ttcp: $(TTCP_DIR)/.configured
	$(TARGET_CC) -O2 -o $(TTCP_DIR)/ttcp $(TTCP_DIR)/$(TTCP_SOURCE)

$(TARGET_DIR)/usr/bin/ttcp: $(TTCP_DIR)/ttcp
	cp -af $(TTCP_DIR)/ttcp $(TARGET_DIR)/usr/bin/

ttcp-legal-info:
	@$(call legal-warning-pkg,ttcp,legal-info not yet implemented)

ttcp: $(TARGET_DIR)/usr/bin/ttcp

ttcp-source: $(DL_DIR)/$(TTCP_SOURCE)

ttcp-clean:
	rm -f $(TTCP_DIR)/*.o $(TTCP_DIR)/ttcp

ttcp-dirclean:
	rm -rf $(TTCP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_TTCP),y)
TARGETS+=ttcp
endif
