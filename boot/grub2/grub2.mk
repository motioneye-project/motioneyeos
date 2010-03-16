#############################################################
#
# grub2
#
# TODO
#
#  * grub2's autogen uses ruby, which isn't part of the core Debian
#    installation. So either decide it is a requirement for Buildroot,
#    or build it for the host.
#
#  * improve the installation procedure. For the moment, it just
#    installs everything in $(TARGET_DIR).
#
#############################################################
GRUB2_SOURCE:=grub2_1.98.orig.tar.gz
GRUB2_PATCH:=grub2_1.98-1.diff.gz
GRUB2_SITE=$(BR2_DEBIAN_MIRROR)/debian/pool/main/g/grub2
GRUB2_PATCH_SITE:=$(GRUB2_SITE)
GRUB2_CAT:=$(ZCAT)
GRUB2_DIR:=$(BUILD_DIR)/grub-1.98
GRUB2_BINARY:=grub2/grub2
GRUB2_TARGET_BINARY:=sbin/grub2
GRUB2_SPLASHIMAGE=$(TOPDIR)/boot/grub/splash.xpm.gz

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
	 $(call DOWNLOAD,$(GRUB2_SITE),$(GRUB2_SOURCE))

$(DL_DIR)/$(GRUB2_PATCH):
	 $(call DOWNLOAD,$(GRUB2_PATCH_SITE),$(GRUB2_PATCH))

grub2-source: $(DL_DIR)/$(GRUB2_SOURCE) $(DL_DIR)/$(GRUB2_PATCH)

$(GRUB2_DIR)/.unpacked: $(DL_DIR)/$(GRUB2_SOURCE) $(DL_DIR)/$(GRUB2_PATCH)
	mkdir -p $(@D)
	$(GRUB2_CAT) $(DL_DIR)/$(GRUB2_SOURCE) | tar $(TAR_STRIP_COMPONENTS)=1 -C $(@D) -xvf -
	toolchain/patch-kernel.sh $(@D) $(DL_DIR) $(GRUB2_PATCH)
	for i in `grep -v "^#" $(@D)/debian/patches/00list`; do \
		cat $(@D)/debian/patches/$$i | patch -p1 -d $(@D); \
	done
	toolchain/patch-kernel.sh $(@D) boot/grub2 grub-\*.patch
	touch $@

$(GRUB2_DIR)/.configured: $(GRUB2_DIR)/.unpacked
	(cd $(GRUB2_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) ; \
		./autogen.sh ; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CPPFLAGS="$(GRUB2_CFLAGS)" \
		grub_cv_i386_check_nested_functions=no \
		./configure $(QUIET) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-grub-mkfont \
		--disable-grub-fstest \
		--disable-grub-emu-usb \
		--disable-werror \
		$(DISABLE_LARGEFILE) \
		$(GRUB2_CONFIG-y) \
	)
	touch $@

$(GRUB2_DIR)/.compiled: $(GRUB2_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(@D)
	touch $@

$(GRUB2_DIR)/.installed: $(GRUB2_DIR)/.compiled
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
	touch $@

grub2: host-automake host-autoconf $(GRUB2_DIR)/.installed

grub2-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GRUB2_DIR) uninstall
	-$(MAKE) -C $(GRUB2_DIR) clean

grub2-dirclean:
	rm -rf $(GRUB2_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_GRUB2),y)
TARGETS+=grub2
endif
