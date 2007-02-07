GRUB_SUPPORTED_ARCH=n
ifeq ($(ARCH),i386)
GRUB_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i486)
GRUB_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i586)
GRUB_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i686)
GRUB_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),x86_64)
GRUB_SUPPORTED_ARCH=y
endif
ifeq ($(GRUB_SUPPORTED_ARCH),y)
#############################################################
#
# grub
#
#############################################################
GRUB_SOURCE:=grub_0.97.orig.tar.gz
GRUB_PATCH:=grub_0.97-22.diff.gz
GRUB_SITE=http://ftp.debian.org/debian/pool/main/g/grub
GRUB_PATCH_SITE:=http://ftp.debian.org/debian/pool/main/g/grub
GRUB_CAT:=$(ZCAT)
GRUB_DIR:=$(BUILD_DIR)/grub-0.97
GRUB_BINARY:=grub/grub
GRUB_TARGET_BINARY:=sbin/grub
GRUB_SPLASHIMAGE=$(TOPDIR)/target/x86/grub/splash.xpm.gz


GRUB_CFLAGS=-DSUPPORT_LOOPDEV
ifeq ($(BR2_LARGEFILE),)
GRUB_CFLAGS+=-U_FILE_OFFSET_BITS
endif


GRUB_CONFIG-$(BR2_TARGET_GRUB_SPLASH) += --enable-graphics
GRUB_CONFIG-$(BR2_TARGET_GRUB_DISKLESS) += --enable-diskless
GRUB_CONFIG-$(BR2_TARGET_GRUB_3c595) += --enable-3c595
GRUB_CONFIG-$(BR2_TARGET_GRUB_3c90x) += --enable-3c90x
GRUB_CONFIG-$(BR2_TARGET_GRUB_davicom) += --enable-davicom
GRUB_CONFIG-$(BR2_TARGET_GRUB_e1000) += --enable-e1000
GRUB_CONFIG-$(BR2_TARGET_GRUB_eepro100) += --enable-eepro100
GRUB_CONFIG-$(BR2_TARGET_GRUB_epic100) += --enable-epic100
GRUB_CONFIG-$(BR2_TARGET_GRUB_forcedeth) += --enable-forcedeth
GRUB_CONFIG-$(BR2_TARGET_GRUB_natsemi) += --enable-natsemi
GRUB_CONFIG-$(BR2_TARGET_GRUB_ns83820) += --enable-ns83820
GRUB_CONFIG-$(BR2_TARGET_GRUB_ns8390) += --enable-ns8390
GRUB_CONFIG-$(BR2_TARGET_GRUB_pcnet32) += --enable-pcnet32
GRUB_CONFIG-$(BR2_TARGET_GRUB_pnic) += --enable-pnic
GRUB_CONFIG-$(BR2_TARGET_GRUB_rtl8139) += --enable-rtl8139
GRUB_CONFIG-$(BR2_TARGET_GRUB_r8169) += --enable-r8169
GRUB_CONFIG-$(BR2_TARGET_GRUB_sis900) += --enable-sis900
GRUB_CONFIG-$(BR2_TARGET_GRUB_tg3) += --enable-tg3
GRUB_CONFIG-$(BR2_TARGET_GRUB_tulip) += --enable-tulip
GRUB_CONFIG-$(BR2_TARGET_GRUB_tlan) += --enable-tlan
GRUB_CONFIG-$(BR2_TARGET_GRUB_undi) += --enable-undi
GRUB_CONFIG-$(BR2_TARGET_GRUB_via_rhine) += --enable-via-rhine
GRUB_CONFIG-$(BR2_TARGET_GRUB_w89c840) += --enable-w89c840

$(DL_DIR)/$(GRUB_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GRUB_SITE)/$(GRUB_SOURCE)

$(DL_DIR)/$(GRUB_PATCH):
	 $(WGET) -P $(DL_DIR) $(GRUB_PATCH_SITE)/$(GRUB_PATCH)

grub-source: $(DL_DIR)/$(GRUB_SOURCE) $(DL_DIR)/$(GRUB_PATCH)

$(GRUB_DIR)/.unpacked: $(DL_DIR)/$(GRUB_SOURCE) $(DL_DIR)/$(GRUB_PATCH)
	$(GRUB_CAT) $(DL_DIR)/$(GRUB_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(GRUB_DIR) $(DL_DIR) $(GRUB_PATCH)
	for i in `grep -v "^#" $(GRUB_DIR)/debian/patches/00list`; do \
		cat $(GRUB_DIR)/debian/patches/$$i | patch -p1 -d $(GRUB_DIR); \
	done
	toolchain/patch-kernel.sh $(GRUB_DIR) target/x86/grub grub.\*.patch{,.bz2}
	touch $@

$(GRUB_DIR)/.configured: $(GRUB_DIR)/.unpacked
	(cd $(GRUB_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS="$(GRUB_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-auto-linux-mem-opt \
		$(GRUB_CONFIG-y) \
	);
	touch $@

$(GRUB_DIR)/$(GRUB_BINARY): $(GRUB_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GRUB_DIR)

$(GRUB_DIR)/.installed: $(GRUB_DIR)/$(GRUB_BINARY)
	cp $(GRUB_DIR)/$(GRUB_BINARY) $(TARGET_DIR)/$(GRUB_TARGET_BINARY)
	test -d $(TARGET_DIR)/boot/grub || mkdir -p $(TARGET_DIR)/boot/grub
	cp $(GRUB_DIR)/stage1/stage1 $(GRUB_DIR)/stage2/*1_5 $(GRUB_DIR)/stage2/stage2 $(TARGET_DIR)/boot/grub/
ifeq ($(BR2_TARGET_GRUB_SPLASH),y)
	test -f $(TARGET_DIR)/boot/grub/$(GRUB_SPLASHIMAGE) || \
		cp $(GRUB_SPLASHIMAGE) $(TARGET_DIR)/boot/grub/
endif
	touch $@

grub: uclibc $(GRUB_DIR)/.installed

grub-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GRUB_DIR) uninstall
	-$(MAKE) -C $(GRUB_DIR) clean
	rm -f $(TARGET_DIR)/boot/grub/$(GRUB_SPLASHIMAGE) \
		$(TARGET_DIR)/sbin/$(GRUB_BINARY) \
		$(TARGET_DIR)/boot/grub/{stage{1,2},*1_5}

grub-dirclean:
	rm -rf $(GRUB_DIR)

endif

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_GRUB)),y)
TARGETS+=grub
endif
