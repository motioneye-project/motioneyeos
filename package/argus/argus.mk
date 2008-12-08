#############################################################
#
# argus
#
#############################################################
ARGUS_VERSION:=3.0.0.rc.34
ARGUS_SOURCE:=argus_$(ARGUS_VERSION).orig.tar.gz
ARGUS_PATCH:=argus_$(ARGUS_VERSION)-1.diff.gz
ARGUS_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/a/argus/
ARGUS_DIR:=$(BUILD_DIR)/argus-$(ARGUS_VERSION)
ARGUS_CAT:=$(ZCAT)
ARGUS_BINARY:=bin/argus
ARGUS_TARGET_BINARY:=usr/sbin/argus

$(DL_DIR)/$(ARGUS_SOURCE):
	$(WGET) -P $(DL_DIR) $(ARGUS_SITE)/$(ARGUS_SOURCE)

$(DL_DIR)/$(ARGUS_PATCH):
	$(WGET) -P $(DL_DIR) $(ARGUS_SITE)/$(ARGUS_PATCH)

argus-source: $(DL_DIR)/$(ARGUS_SOURCE) $(DL_DIR)/$(ARGUS_PATCH)

$(ARGUS_DIR)/.unpacked: $(DL_DIR)/$(ARGUS_SOURCE) $(DL_DIR)/$(ARGUS_PATCH)
	$(ARGUS_CAT) $(DL_DIR)/$(ARGUS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(ARGUS_DIR) package/argus/ argus\*.patch
ifneq ($(ARGUS_PATCH),)
	(cd $(ARGUS_DIR) && $(ARGUS_CAT) $(DL_DIR)/$(ARGUS_PATCH) | patch -p1)
	if [ -d $(ARGUS_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(ARGUS_DIR) $(ARGUS_DIR)/debian/patches \*.patch; \
	fi
endif
	touch $@

$(ARGUS_DIR)/.configured: $(ARGUS_DIR)/.unpacked
	(cd $(ARGUS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(ARGUS_DIR)/$(ARGUS_BINARY): $(ARGUS_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(ARGUS_DIR)

$(TARGET_DIR)/$(ARGUS_TARGET_BINARY): $(ARGUS_DIR)/$(ARGUS_BINARY)
	cp -dpf $(ARGUS_DIR)/$(ARGUS_BINARY) $@
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

argus: uclibc libpcap $(TARGET_DIR)/$(ARGUS_TARGET_BINARY)

argus-clean:
	-$(MAKE) -C $(ARGUS_DIR) clean
	rm -f $(TARGET_DIR)/$(ARGUS_TARGET_BINARY)

argus-dirclean:
	rm -rf $(ARGUS_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_ARGUS),y)
TARGETS+=argus
endif
