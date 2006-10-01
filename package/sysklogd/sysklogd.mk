#############################################################
#
# sysklogd
#
#############################################################
SYSKLOGD_VER:=1.4.1
SYSKLOGD_SOURCE:=sysklogd-$(SYSKLOGD_VER).tar.gz
SYSKLOGD_SITE:=http://www.infodrom.org/projects/sysklogd/download
SYSKLOGD_DIR:=$(BUILD_DIR)/sysklogd-$(SYSKLOGD_VER)
SYSKLOGD_SYSLOGD_BINARY:=syslogd
SYSKLOGD_KLOGD_BINARY:=klogd
SYSKLOGD_BINARY:=$(SYSKLOGD_KLOGD_BINARY)
SYSKLOGD_SYSLOGD_TARGET_BINARY:=sbin/syslogd
SYSKLOGD_KLOGD_TARGET_BINARY:=sbin/klogd
SYSKLOGD_TARGET_BINARY:=$(SYSKLOGD_KLOGD_TARGET_BINARY)

$(DL_DIR)/$(SYSKLOGD_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SYSKLOGD_SITE)/$(SYSKLOGD_SOURCE)

sysklogd-source: $(DL_DIR)/$(SYSKLOGD_SOURCE)

$(SYSKLOGD_DIR)/.unpacked: $(DL_DIR)/$(SYSKLOGD_SOURCE)
	$(ZCAT) $(DL_DIR)/$(SYSKLOGD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SYSKLOGD_DIR) package/sysklogd/ sysklogd\*.patch
	touch $(SYSKLOGD_DIR)/.unpacked

$(SYSKLOGD_DIR)/$(SYSKLOGD_BINARY): $(SYSKLOGD_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) -C $(SYSKLOGD_DIR)
	$(STRIP) $(SYSKLOGD_DIR)/$(SYSKLOGD_SYSLOGD_BINARY)
	$(STRIP) $(SYSKLOGD_DIR)/$(SYSKLOGD_KLOGD_BINARY)

$(TARGET_DIR)/$(SYSKLOGD_TARGET_BINARY): $(SYSKLOGD_DIR)/$(SYSKLOGD_BINARY)
	$(INSTALL) -m 0755 -D $(SYSKLOGD_DIR)/$(SYSKLOGD_SYSLOGD_BINARY) $(TARGET_DIR)/$(SYSKLOGD_SYSLOGD_TARGET_BINARY)
	$(INSTALL) -m 0755 -D $(SYSKLOGD_DIR)/$(SYSKLOGD_KLOGD_BINARY) $(TARGET_DIR)/$(SYSKLOGD_KLOGD_TARGET_BINARY)
	$(INSTALL) -m 0755 -D package/sysklogd/init-syslog $(TARGET_DIR)/etc/init.d/S25syslog
	$(INSTALL) -m 0644 -D package/sysklogd/syslog.conf $(TARGET_DIR)/etc/syslog.conf

sysklogd: uclibc $(TARGET_DIR)/$(SYSKLOGD_TARGET_BINARY)

sysklogd-clean:
	rm -f $(TARGET_DIR)/$(SYSKLOGD_SYSLOGD_TARGET_BINARY)
	rm -f $(TARGET_DIR)/$(SYSKLOGD_KLOGD_TARGET_BINARY)
	rm -f $(TARGET_DIR)/etc/init.d/S25syslogd
	rm -f $(TARGET_DIR)/etc/syslog.conf
	-$(MAKE) -C $(SYSKLOGD_DIR) clean

sysklogd-dirclean:
	rm -rf $(SYSKLOGD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SYSKLOGD)),y)
TARGETS+=sysklogd
endif
