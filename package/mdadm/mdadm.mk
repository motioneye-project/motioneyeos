#############################################################
#
# mdadm
#
#############################################################
MDADM_VERSION:=2.6.1
MDADM_SOURCE:=mdadm-$(MDADM_VERSION).tar.bz2
MDADM_CAT:=$(BZCAT)
MDADM_SITE:=http://www.kernel.org/pub/linux/utils/raid/mdadm
MDADM_DIR:=$(BUILD_DIR)/mdadm-$(MDADM_VERSION)
MDADM_BINARY:=mdadm
MDADM_TARGET_BINARY:=sbin/mdadm

$(DL_DIR)/$(MDADM_SOURCE):
	$(WGET) -P $(DL_DIR) $(MDADM_SITE)/$(MDADM_SOURCE)

$(MDADM_DIR)/.unpacked: $(DL_DIR)/$(MDADM_SOURCE)
	$(MDADM_CAT) $(DL_DIR)/$(MDADM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MDADM_DIR) package/mdadm mdadm-$(MDADM_VERSION)\*.patch
	touch $@

$(MDADM_DIR)/$(MDADM_BINARY): $(MDADM_DIR)/.unpacked
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" CC=$(TARGET_CC) -C $(MDADM_DIR)

$(TARGET_DIR)/$(MDADM_TARGET_BINARY): $(MDADM_DIR)/$(MDADM_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(MDADM_DIR) install
	rm -Rf $(TARGET_DIR)/usr/share/man
	$(STRIP) -s $@

mdadm: uclibc $(TARGET_DIR)/$(MDADM_TARGET_BINARY)

mdadm-source: $(DL_DIR)/$(MDADM_SOURCE)

mdadm-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(MDADM_DIR) uninstall
	-$(MAKE) -C $(MDADM_DIR) clean

mdadm-dirclean:
	rm -rf $(MDADM_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MDADM)),y)
TARGETS+=mdadm
endif
