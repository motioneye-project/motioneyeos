#############################################################
#
# mdadm
#
#############################################################
MDADM_VERSION:=2.6.2
MDADM_SOURCE:=mdadm_$(MDADM_VERSION).orig.tar.gz
MDADM_PATCH:=mdadm_$(MDADM_VERSION)-1.diff.gz
MDADM_CAT:=$(ZCAT)
MDADM_SITE:=http://ftp.debian.org/debian/pool/main/m/mdadm
MDADM_DIR:=$(BUILD_DIR)/mdadm-$(MDADM_VERSION)
MDADM_BINARY:=mdadm
MDADM_TARGET_BINARY:=sbin/mdadm

ifneq ($(MDADM_PATCH),)
MDADM_PATCH_FILE:=$(DL_DIR)/$(MDADM_PATCH)
$(MDADM_PATCH_FILE):
	$(WGET) -P $(DL_DIR) $(MDADM_SITE)/$(MDADM_PATCH)
endif

$(DL_DIR)/$(MDADM_SOURCE): $(MDADM_PATCH_FILE)
	$(WGET) -P $(DL_DIR) $(MDADM_SITE)/$(MDADM_SOURCE)
	touch -c $@

$(MDADM_DIR)/.unpacked: $(DL_DIR)/$(MDADM_SOURCE)
	$(MDADM_CAT) $(DL_DIR)/$(MDADM_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(MDADM_PATCH),)
	(cd $(MDADM_DIR) && $(MDADM_CAT) $(MDADM_PATCH_FILE) | patch -p1)
	if [ -d $(MDADM_DIR)/debian/patches ]; then \
	  toolchain/patch-kernel.sh $(MDADM_DIR) $(MDADM_DIR)/debian/patches \*patch; \
	fi
endif
	#toolchain/patch-kernel.sh $(MDADM_DIR) package/mdadm mdadm-$(MDADM_VERSION)\*.patch
	toolchain/patch-kernel.sh $(MDADM_DIR) package/mdadm mdadm-\*.patch
	touch $@

$(MDADM_DIR)/$(MDADM_BINARY): $(MDADM_DIR)/.unpacked
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" CC=$(TARGET_CC) -C $(MDADM_DIR)

$(TARGET_DIR)/$(MDADM_TARGET_BINARY): $(MDADM_DIR)/$(MDADM_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(MDADM_DIR) install
	rm -Rf $(TARGET_DIR)/usr/share/man
	$(STRIP) $(STRIP_STRIP_ALL) $@

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
