#############################################################
#
# patch
#
#############################################################
GNUPATCH_VERSION:=2.5.9
GNUPATCH_SOURCE:=patch_$(GNUPATCH_VERSION).orig.tar.gz
GNUPATCH_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/p/patch
GNUPATCH_CAT:=$(ZCAT)
GNUPATCH_DIR:=$(BUILD_DIR)/patch-$(GNUPATCH_VERSION)
GNUPATCH_BINARY:=patch
GNUPATCH_TARGET_BINARY:=usr/bin/patch

$(DL_DIR)/$(GNUPATCH_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GNUPATCH_SITE)/$(GNUPATCH_SOURCE)

patch-source: $(DL_DIR)/$(GNUPATCH_SOURCE)

$(GNUPATCH_DIR)/.unpacked: $(DL_DIR)/$(GNUPATCH_SOURCE)
	$(GNUPATCH_CAT) $(DL_DIR)/$(GNUPATCH_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(GNUPATCH_DIR)
	touch $(GNUPATCH_DIR)/.unpacked

$(GNUPATCH_DIR)/.configured: $(GNUPATCH_DIR)/.unpacked
	(cd $(GNUPATCH_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $(GNUPATCH_DIR)/.configured

$(GNUPATCH_DIR)/$(GNUPATCH_BINARY): $(GNUPATCH_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GNUPATCH_DIR)

$(TARGET_DIR)/$(GNUPATCH_TARGET_BINARY): $(GNUPATCH_DIR)/$(GNUPATCH_BINARY)
	rm -f $(TARGET_DIR)/$(GNUPATCH_TARGET_BINARY)
	cp -a $(GNUPATCH_DIR)/$(GNUPATCH_BINARY) $(TARGET_DIR)/$(GNUPATCH_TARGET_BINARY)

patch: uclibc $(TARGET_DIR)/$(GNUPATCH_TARGET_BINARY)

patch-clean:
	rm -f $(TARGET_DIR)/$(GNUPATCH_TARGET_BINARY)

patch-dirclean:
	rm -rf $(GNUPATCH_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_PATCH),y)
TARGETS+=patch
endif
