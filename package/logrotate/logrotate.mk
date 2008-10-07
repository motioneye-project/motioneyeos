LOGROTATE_VERSION:=3.7.7
LOGROTATE_SOURCE:=logrotate-$(LOGROTATE_VERSION).tar.gz
LOGROTATE_SITE:=https://fedorahosted.org/releases/l/o/logrotate/
LOGROTATE_DIR:=$(BUILD_DIR)/logrotate-$(LOGROTATE_VERSION)
LOGROTATE_BINARY:=logrotate
LOGROTATE_TARGET_BINARY:=usr/sbin/$(LOGROTATE_BINARY)

$(DL_DIR)/$(LOGROTATE_SOURCE):
	$(WGET) -P $(DL_DIR) $(LOGROTATE_SITE)/$(LOGROTATE_SOURCE)

$(LOGROTATE_DIR)/.source: $(DL_DIR)/$(LOGROTATE_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LOGROTATE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LOGROTATE_DIR) package/logrotate/ *.patch	
	touch $@

$(LOGROTATE_DIR)/$(LOGROTATE_BINARY): $(LOGROTATE_DIR)/.source
	$(MAKE) CC=$(TARGET_CC) -C $(LOGROTATE_DIR)

$(TARGET_DIR)/$(LOGROTATE_TARGET_BINARY): $(LOGROTATE_DIR)/$(LOGROTATE_BINARY)
	$(MAKE) PREFIX=$(TARGET_DIR) -C $(LOGROTATE_DIR) install
	$(INSTALL) -m 0644 package/logrotate/logrotate.conf $(TARGET_DIR)/etc/logrotate.conf
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/logrotate.d

logrotate: popt $(TARGET_DIR)/$(LOGROTATE_TARGET_BINARY)

logrotate-source: $(DL_DIR)/$(LOGROTATE_SOURCE)

logrotate-clean:
	rm -f $(TARGET_DIR)/$(LOGROTATE_TARGET_BINARY)
	rm -f $(TARGET_DIR)/etc/logrotate.conf
	-rmdir $(TARGET_DIR)/etc/logrotate.d
	-$(MAKE) -C $(LOGROTATE_DIR) clean

logrotate-dirclean:
	rm -rf $(LOGROTATE_DIR)

ifeq ($(BR2_PACKAGE_LOGROTATE),y)
TARGETS+=logrotate
endif

