#############################################################
#
# portmap
#
#############################################################
PORTMAP_VER:=5b
PORTMAP_SOURCE:=portmap_$(PORTMAP_VER)eta.tar.gz
PORTMAP_SITE:=ftp://ftp.porcupine.org/pub/security/
PORTMAP_DIR:=$(BUILD_DIR)/portmap_$(PORTMAP_VER)eta
PORTMAP_CAT:=$(ZCAT)
PORTMAP_BINARY:=portmap
PORTMAP_TARGET_BINARY:=sbin/portmap

$(DL_DIR)/$(PORTMAP_SOURCE):
	$(WGET) -P $(DL_DIR) $(PORTMAP_SITE)/$(PORTMAP_SOURCE)

portmap-source: $(DL_DIR)/$(PORTMAP_SOURCE)

$(PORTMAP_DIR)/.unpacked: $(DL_DIR)/$(PORTMAP_SOURCE)
	$(PORTMAP_CAT) $(DL_DIR)/$(PORTMAP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(PORTMAP_DIR) package/portmap/ portmap\*.patch
	touch $(PORTMAP_DIR)/.unpacked

$(PORTMAP_DIR)/$(PORTMAP_BINARY): $(PORTMAP_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) O="$(TARGET_CFLAGS)" -C $(PORTMAP_DIR)

$(TARGET_DIR)/$(PORTMAP_TARGET_BINARY): $(PORTMAP_DIR)/$(PORTMAP_BINARY)
	$(INSTALL) -D $(PORTMAP_DIR)/$(PORTMAP_BINARY) $(TARGET_DIR)/$(PORTMAP_TARGET_BINARY)
	$(INSTALL) -m 0755 package/portmap/S13portmap $(TARGET_DIR)/etc/init.d

portmap: uclibc $(TARGET_DIR)/$(PORTMAP_TARGET_BINARY)

portmap-clean:
	rm -f $(TARGET_DIR)/$(PORTMAP_TARGET_BINARY)
	rm -f $(TARGET_DIR)/etc/init.d/S13portmap
	-$(MAKE) -C $(PORTMAP_DIR) clean

portmap-dirclean:
	rm -rf $(PORTMAP_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PORTMAP)),y)
TARGETS+=portmap
endif
