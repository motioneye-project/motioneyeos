GRUB2_SUPPORTED_ARCH=n
ifeq ($(ARCH),i386)
GRUB2_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i486)
GRUB2_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i586)
GRUB2_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i686)
GRUB2_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),x86_64)
GRUB2_SUPPORTED_ARCH=y
endif
ifeq ($(GRUB2_SUPPORTED_ARCH),y)
#############################################################
#
# grub2
#
#############################################################
GRUB2_SOURCE:=grub2_1.95.orig.tar.gz
GRUB2_PATCH:=grub2_1.95-5.diff.gz
GRUB2_SITE=$(BR2_DEBIAN_MIRROR)/debian/pool/main/g/grub2
GRUB2_PATCH_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/g/grub2
GRUB2_CAT:=$(ZCAT)
GRUB2_DIR:=$(BUILD_DIR)/grub-1.95
GRUB2_BINARY:=grub2/grub2
GRUB2_TARGET_BINARY:=sbin/grub2
GRUB2_SPLASHIMAGE=$(TOPDIR)/target/x86/grub/splash.xpm.gz


GRUB2_CFLAGS=-DSUPPORT_LOOPDEV
ifeq ($(BR2_LARGEFILE),)
GRUB2_CFLAGS+=-U_FILE_OFFSET_BITS
endif


GRUB2_CONFIG-$(BR2_TARGET_GRUB2_SPLASH) += --enable-graphics
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_DISKLESS) += --enable-diskless
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_3c595) += --enable-3c595
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_3c90x) += --enable-3c90x
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_davicom) += --enable-davicom
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_e1000) += --enable-e1000
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_eepro100) += --enable-eepro100
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_epic100) += --enable-epic100
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_forcedeth) += --enable-forcedeth
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_natsemi) += --enable-natsemi
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_ns83820) += --enable-ns83820
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_ns8390) += --enable-ns8390
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_pcnet32) += --enable-pcnet32
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_pnic) += --enable-pnic
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_rtl8139) += --enable-rtl8139
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_r8169) += --enable-r8169
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_sis900) += --enable-sis900
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_tg3) += --enable-tg3
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_tulip) += --enable-tulip
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_tlan) += --enable-tlan
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_undi) += --enable-undi
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_via_rhine) += --enable-via-rhine
GRUB2_CONFIG-$(BR2_TARGET_GRUB2_w89c840) += --enable-w89c840

$(DL_DIR)/$(GRUB2_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GRUB2_SITE)/$(GRUB2_SOURCE)

$(DL_DIR)/$(GRUB2_PATCH):
	 $(WGET) -P $(DL_DIR) $(GRUB2_PATCH_SITE)/$(GRUB2_PATCH)

grub2-source: $(DL_DIR)/$(GRUB2_SOURCE) $(DL_DIR)/$(GRUB2_PATCH)

$(GRUB2_DIR)/.unpacked: $(DL_DIR)/$(GRUB2_SOURCE) $(DL_DIR)/$(GRUB2_PATCH)
	$(GRUB2_CAT) $(DL_DIR)/$(GRUB2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(GRUB2_DIR) $(DL_DIR) $(GRUB2_PATCH)
	for i in `grep -v "^#" $(GRUB2_DIR)/debian/patches/00list`; do \
		cat $(GRUB2_DIR)/debian/patches/$$i | patch -p1 -d $(GRUB2_DIR); \
	done
	toolchain/patch-kernel.sh $(GRUB2_DIR) target/x86/grub2 grub-\*.patch
	touch $@

$(GRUB2_DIR)/.configured: $(GRUB2_DIR)/.unpacked
	(cd $(GRUB2_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CPPFLAGS="$(GRUB2_CFLAGS)" \
		grub_cv_i386_check_nested_functions=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-auto-linux-mem-opt \
		$(DISABLE_LARGEFILE) \
		$(GRUB2_CONFIG-y) \
	)
	touch $@

$(GRUB2_DIR)/$(GRUB2_BINARY): $(GRUB2_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GRUB2_DIR)

$(GRUB2_DIR)/.installed: $(GRUB2_DIR)/$(GRUB2_BINARY)
	cp $(GRUB2_DIR)/$(GRUB2_BINARY) $(TARGET_DIR)/$(GRUB2_TARGET_BINARY)
	test -d $(TARGET_DIR)/boot/grub2 || mkdir -p $(TARGET_DIR)/boot/grub2
	cp $(GRUB2_DIR)/stage1/stage1 $(GRUB2_DIR)/stage2/*1_5 $(GRUB2_DIR)/stage2/stage2 $(TARGET_DIR)/boot/grub2/
ifeq ($(BR2_TARGET_GRUB2_SPLASH),y)
	test -f $(TARGET_DIR)/boot/grub2/$(GRUB2_SPLASHIMAGE) || \
		cp $(GRUB2_SPLASHIMAGE) $(TARGET_DIR)/boot/grub2/
endif
	touch $@

grub2: uclibc $(GRUB2_DIR)/.installed

grub2-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GRUB2_DIR) uninstall
	-$(MAKE) -C $(GRUB2_DIR) clean
	rm -f $(TARGET_DIR)/boot/grub2/$(GRUB2_SPLASHIMAGE) \
		$(TARGET_DIR)/sbin/$(GRUB2_BINARY) \
		$(TARGET_DIR)/boot/grub2/{stage{1,2},*1_5}

grub2-dirclean:
	rm -rf $(GRUB2_DIR)

endif

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_GRUB2)),y)
TARGETS+=grub2
endif
