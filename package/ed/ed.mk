#############################################################
#
# ed
#
#############################################################
ED_SOURCE:=ed_0.2.orig.tar.gz
ED_PATCH:=ed_0.2-20.diff.gz
ED_SITE:=http://ftp.debian.org/debian/pool/main/e/ed
ED_CAT:=$(ZCAT)
ED_DIR:=$(BUILD_DIR)/ed-0.2
ED_BINARY:=ed
ED_TARGET_BINARY:=bin/ed

$(DL_DIR)/$(ED_SOURCE):
	 $(WGET) -P $(DL_DIR) $(ED_SITE)/$(ED_SOURCE)

$(DL_DIR)/$(ED_PATCH):
	 $(WGET) -P $(DL_DIR) $(ED_SITE)/$(ED_PATCH)

ed-source: $(DL_DIR)/$(ED_SOURCE) $(DL_DIR)/$(ED_PATCH)

$(ED_DIR)/.unpacked: $(DL_DIR)/$(ED_SOURCE) $(DL_DIR)/$(ED_PATCH)
	$(ED_CAT) $(DL_DIR)/$(ED_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(ED_DIR) $(DL_DIR) $(ED_PATCH)
	if [ -d $(ED_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(ED_DIR) $(ED_DIR)/debian/patches \*.patch ; \
	fi
	toolchain/patch-kernel.sh $(ED_DIR) package/ed/ ed-*.patch
	touch $@

$(ED_DIR)/.configured: $(ED_DIR)/.unpacked
	(cd $(ED_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		$(DISABLE_NLS) \
	);
	touch $@

$(ED_DIR)/$(ED_BINARY): $(ED_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(ED_DIR)

$(TARGET_DIR)/$(ED_TARGET_BINARY): $(ED_DIR)/$(ED_BINARY)
	cp -dpf $(ED_DIR)/$(ED_BINARY) $(TARGET_DIR)/$(ED_TARGET_BINARY)

ed: uclibc $(TARGET_DIR)/$(ED_TARGET_BINARY)

ed-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(ED_DIR) uninstall
	-$(MAKE) -C $(ED_DIR) clean

ed-dirclean:
	rm -rf $(ED_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ED)),y)
TARGETS+=ed
endif
