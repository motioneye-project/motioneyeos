#############################################################
#
# pptp-linux
#
#############################################################
PPTP_LINUX_VERSION:=1.7.0
PPTP_LINUX_SOURCE:=pptp-linux_$(PPTP_LINUX_VERSION).orig.tar.gz
#PPTP_LINUX_PATCH:=pptp-linux_$(PPTP_LINUX_VERSION)-2.diff.gz
PPTP_LINUX_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/p/pptp-linux
PPTP_LINUX_DIR:=$(BUILD_DIR)/pptp-linux-$(PPTP_LINUX_VERSION).orig
PPTP_LINUX_CAT:=$(ZCAT)
PPTP_LINUX_BINARY:=pptp
PPTP_LINUX_TARGET_BINARY:=usr/sbin/pptp

$(DL_DIR)/$(PPTP_LINUX_SOURCE):
	$(WGET) -P $(DL_DIR) $(PPTP_LINUX_SITE)/$(PPTP_LINUX_SOURCE)

ifneq ($(PPTP_LINUX_PATCH),)
PPTP_LINUX_PATCH_FILE:=$(DL_DIR)/$(PPTP_LINUX_PATCH)
$(PPTP_LINUX_PATCH_FILE):
	$(WGET) -P $(DL_DIR) $(PPTP_LINUX_SITE)/$(PPTP_LINUX_PATCH)
endif

$(PPTP_LINUX_DIR)/.unpacked: $(DL_DIR)/$(PPTP_LINUX_SOURCE) $(PPTP_LINUX_PATCH_FILE)
	$(PPTP_LINUX_CAT) $(DL_DIR)/$(PPTP_LINUX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(PPTP_LINUX_PATCH),)
	(cd $(PPTP_LINUX_DIR) && $(PPTP_LINUX_CAT) $(DL_DIR)/$(PPTP_LINUX_PATCH) | patch -p1)
	if [ -d $(PPTP_LINUX_DIR)/debian/patches ]; then \
		toolchain/patch-kernel.sh $(PPTP_LINUX_DIR) $(PPTP_LINUX_DIR)/debian/patches \*.patch; \
	fi
endif
	toolchain/patch-kernel.sh $(PPTP_LINUX_DIR) package/pptp-linux/ pptp-linux\*.patch
	touch $@

$(PPTP_LINUX_DIR)/.configured: $(PPTP_LINUX_DIR)/.unpacked
	(cd $(PPTP_LINUX_DIR); rm -rf config.cache; \
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

$(PPTP_LINUX_DIR)/$(PPTP_LINUX_BINARY): $(PPTP_LINUX_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) OPTIMIZE="$(TARGET_CFLAGS)" \
		-C $(PPTP_LINUX_DIR)

$(TARGET_DIR)/$(PPTP_LINUX_TARGET_BINARY): $(PPTP_LINUX_DIR)/$(PPTP_LINUX_BINARY)
	cp -dpf $(PPTP_LINUX_DIR)/$(PPTP_LINUX_BINARY) $@
ifeq ($(BR2_HAVE_MANPAGES),y)
	mkdir -p $(TARGET_DIR)/usr/share/man/man8
	$(INSTALL) -m 644 $(PPTP_LINUX_DIR)/pptp.8 $(TARGET_DIR)/usr/share/man/man8/pptp.8
endif
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

pptp-linux: uclibc $(TARGET_DIR)/$(PPTP_LINUX_TARGET_BINARY)

pptp-linux-source: $(DL_DIR)/$(PPTP_LINUX_SOURCE) $(PPTP_LINUX_PATCH_FILE)

pptp-linux-clean:
	-$(MAKE) -C $(PPTP_LINUX_DIR) distclean
	rm -f $(TARGET_DIR)/$(PPTP_LINUX_TARGET_BINARY) \
		$(TARGET_DIR)/usr/share/man/man8/pptp.8*

pptp-linux-dirclean:
	rm -rf $(PPTP_LINUX_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PPTP_LINUX)),y)
TARGETS+=pptp-linux
endif
