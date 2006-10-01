ifeq ($(ARCH),i386)
#############################################################
#
# grub
#
#############################################################
GRUB_SOURCE:=grub_0.97.orig.tar.gz
GRUB_PATCH=grub_0.97-5.diff.gz
GRUB_SITE=http://ftp.debian.org/debian/pool/main/g/grub
GRUB_CAT:=$(ZCAT)
GRUB_DIR:=$(BUILD_DIR)/grub-0.97
GRUB_BINARY:=grub/grub
GRUB_TARGET_BINARY:=bin/grub

ifeq ($(BR2_TARGET_GRUB_SPLASH),y)
GRUB_CONFIGURE_ARGS+=--enable-graphics
GRUB_SPLASHIMAGE=splash.xpm.gz
endif
GRUB_CFLAGS=-DSUPPORT_LOOPDEV

$(DL_DIR)/$(GRUB_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GRUB_SITE)/$(GRUB_SOURCE)

$(DL_DIR)/$(GRUB_PATCH):
	 $(WGET) -P $(DL_DIR) $(GRUB_SITE)/$(GRUB_PATCH)

grub-source: $(DL_DIR)/$(GRUB_SOURCE) $(DL_DIR)/$(GRUB_PATCH)

$(GRUB_DIR)/.unpacked: $(DL_DIR)/$(GRUB_SOURCE) $(DL_DIR)/$(GRUB_PATCH)
	$(GRUB_CAT) $(DL_DIR)/$(GRUB_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	$(GRUB_CAT) $(DL_DIR)/$(GRUB_PATCH)  | patch -p1 -d $(GRUB_DIR)
	for i in `grep -v "^#" $(GRUB_DIR)/debian/patches/00list`; do \
		cat $(GRUB_DIR)/debian/patches/$$i | patch -p1 -d $(GRUB_DIR); \
	done
	toolchain/patch-kernel.sh $(GRUB_DIR) target/x86/grub/ grub\*.patch
	touch $(GRUB_DIR)/.unpacked

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
		$(GRUB_CONFIGURE_ARGS) \
	);
	touch  $(GRUB_DIR)/.configured

$(GRUB_DIR)/$(GRUB_BINARY): $(GRUB_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GRUB_DIR)

grub-target_binary: $(GRUB_DIR)/$(GRUB_BINARY)

grub: grub-target_binary

grub-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GRUB_DIR) uninstall
	-grub -C $(GRUB_DIR) clean

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
