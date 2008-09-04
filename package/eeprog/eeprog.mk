#############################################################
#
# eeprog
#
#############################################################
EEPROG_VERSION:=0.7.6
EEPROG_SOURCE:=eeprog-$(EEPROG_VERSION).tar.gz
EEPROG_SITE:=http://codesink.org/download
EEPROG_DIR:=$(BUILD_DIR)/eeprog-$(EEPROG_VERSION)
EEPROG_BINARY:=eeprog
EEPROG_TARGET_BINARY:=usr/sbin/eeprog

$(DL_DIR)/$(EEPROG_SOURCE):
	 $(WGET) -P $(DL_DIR) $(EEPROG_SITE)/$(EEPROG_SOURCE)

eeprog-source: $(DL_DIR)/$(EEPROG_SOURCE)

$(EEPROG_DIR)/.unpacked: $(DL_DIR)/$(EEPROG_SOURCE)
	$(ZCAT) $(DL_DIR)/$(EEPROG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(EEPROG_DIR) package/eeprog/ eeprog\*.patch
	touch $(EEPROG_DIR)/.unpacked

$(EEPROG_DIR)/$(EEPROG_BINARY): $(EEPROG_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(EEPROG_DIR)
	$(STRIPCMD) $(EEPROG_DIR)/$(EEPROG_BINARY)

$(TARGET_DIR)/$(EEPROG_TARGET_BINARY): $(EEPROG_DIR)/$(EEPROG_BINARY)
	$(INSTALL) -m 0755 -D $(EEPROG_DIR)/$(EEPROG_BINARY) $(TARGET_DIR)/$(EEPROG_TARGET_BINARY)

eeprog: uclibc $(TARGET_DIR)/$(EEPROG_TARGET_BINARY)

eeprog-clean:
	rm -f $(TARGET_DIR)/$(EEPROG_TARGET_BINARY)
	-$(MAKE) -C $(EEPROG_DIR) clean

eeprog-dirclean:
	rm -rf $(EEPROG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_EEPROG)),y)
TARGETS+=eeprog
endif
