#############################################################
#
# argus
#
#############################################################
ARGUS_VER:=3.0.0.rc.34
ARGUS_SOURCE:=argus_$(ARGUS_VER).orig.tar.gz
ARGUS_PATCH:=argus_$(ARGUS_VER)-1.diff.gz
ARGUS_SITE:=ftp://ftp.debian.org/debian/pool/main/a/argus/
ARGUS_DIR:=$(BUILD_DIR)/argus-$(ARGUS_VER)
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
		toolchain/patch-kernel.sh $(ARGUS_DIR) $(ARGUS_DIR)/debian/patches \*.patch ; \
	fi
endif
	touch $@

$(ARGUS_DIR)/.configured: $(ARGUS_DIR)/.unpacked
	(cd $(ARGUS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(DISABLE_LARGEFILE) \
	);
	touch $@

$(ARGUS_DIR)/$(ARGUS_BINARY): $(ARGUS_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(ARGUS_DIR)

$(TARGET_DIR)/$(ARGUS_TARGET_BINARY): $(ARGUS_DIR)/$(ARGUS_BINARY)
	cp -dpf $(ARGUS_DIR)/$(ARGUS_BINARY) $@
	$(STRIP) -s $@

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
ifeq ($(strip $(BR2_PACKAGE_ARGUS)),y)
TARGETS+=argus
endif
