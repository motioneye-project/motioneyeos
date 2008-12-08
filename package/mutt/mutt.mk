#############################################################
#
# mutt
#
#############################################################
MUTT_VERSION:=1.5.17+20080114
MUTT_SOURCE:=mutt_$(MUTT_VERSION).orig.tar.gz
MUTT_PATCH:=mutt_$(MUTT_VERSION)-1.diff.gz
MUTT_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/m/mutt/
MUTT_DIR:=$(BUILD_DIR)/mutt-$(MUTT_VERSION)
MUTT_CAT:=$(ZCAT)
MUTT_BINARY:=mutt
MUTT_TARGET_BINARY:=usr/bin/mutt

$(DL_DIR)/$(MUTT_SOURCE):
	$(WGET) -P $(DL_DIR) $(MUTT_SITE)/$(MUTT_SOURCE)

$(DL_DIR)/$(MUTT_PATCH):
	$(WGET) -P $(DL_DIR) $(MUTT_SITE)/$(MUTT_PATCH)

$(MUTT_DIR)/.unpacked: $(DL_DIR)/$(MUTT_SOURCE) $(DL_DIR)/$(MUTT_PATCH)
	$(MUTT_CAT) $(DL_DIR)/$(MUTT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MUTT_DIR) package/mutt/ mutt-$(MUTT_VERSION)\*.patch
ifneq ($(MUTT_PATCH),)
	(cd $(MUTT_DIR) && $(MUTT_CAT) $(DL_DIR)/$(MUTT_PATCH) | patch -p1)
	if [ -d $(MUTT_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(MUTT_DIR) $(MUTT_DIR)/debian/patches \*.patch; \
	fi
endif
	touch $@

$(MUTT_DIR)/.configured: $(MUTT_DIR)/.unpacked
	(cd $(MUTT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		$(DISABLE_LARGEFILE) \
		$(DISABLE_IPV6) \
		$(DISABLE_NLS) \
		--disable-smtp \
		--disable-iconv \
		--without-wc-funcs \
	)
	touch $@

$(MUTT_DIR)/$(MUTT_BINARY): $(MUTT_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(MUTT_DIR)

$(TARGET_DIR)/$(MUTT_TARGET_BINARY): $(MUTT_DIR)/$(MUTT_BINARY)
	cp -dpf $(MUTT_DIR)/$(MUTT_BINARY) $@
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

mutt-source: $(DL_DIR)/$(MUTT_SOURCE) $(DL_DIR)/$(MUTT_PATCH)

mutt-unpacked: $(MUTT_DIR)/.unpacked

mutt: uclibc ncurses $(TARGET_DIR)/$(MUTT_TARGET_BINARY)

mutt-clean:
	-$(MAKE) -C $(MUTT_DIR) clean
	rm -f $(TARGET_DIR)/$(MUTT_TARGET_BINARY)

mutt-dirclean:
	rm -rf $(MUTT_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_MUTT),y)
TARGETS+=mutt
endif
