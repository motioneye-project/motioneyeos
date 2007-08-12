#############################################################
#
# directfb
#
#############################################################
DIRECTFB_VERSION:=0.9.25.1
DIRECTFB_SOURCE:=DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_SITE:=http://www.directfb.org/downloads/Old
DIRECTFB_CAT:=$(ZCAT)
DIRECTFB_DIR:=$(BUILD_DIR)/DirectFB-$(DIRECTFB_VERSION)

$(DL_DIR)/$(DIRECTFB_SOURCE):
	$(WGET) -P $(DL_DIR) $(DIRECTFB_SITE)/$(DIRECTFB_SOURCE)

directfb-source: $(DL_DIR)/$(DIRECTFB_SOURCE)

$(DIRECTFB_DIR)/.unpacked: $(DL_DIR)/$(DIRECTFB_SOURCE)
	$(DIRECTFB_CAT) $(DL_DIR)/$(DIRECTFB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DIRECTFB_DIR) package/directfb/ directfb\*.patch
	touch $(DIRECTFB_DIR)/.unpacked

$(DIRECTFB_DIR)/.configured: $(DIRECTFB_DIR)/.unpacked
	(cd $(DIRECTFB_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
	ac_cv_header_linux_wm97xx_h=no \
	ac_cv_header_linux_sisfb_h=no \
	ac_cv_header_asm_page_h=no \
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
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-gfxdrivers=cle266,unichrome \
		--enable-shared \
		--enable-jpeg \
		--enable-png \
		--enable-linux-input \
		--enable-zlib \
		--enable-freetype \
		--disable-sysfs \
		--enable-sdl \
		--disable-video4linux \
		--disable-video4linux2 \
		--disable-fusion );
	touch $(DIRECTFB_DIR)/.configured

$(DIRECTFB_DIR)/.compiled: $(DIRECTFB_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(DIRECTFB_DIR)
	touch $(DIRECTFB_DIR)/.compiled

$(STAGING_DIR)/usr/lib/libdirectfb.so: $(DIRECTFB_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR)/usr -C $(DIRECTFB_DIR) install
	touch -c $@

$(TARGET_DIR)/usr/lib/libdirectfb.so: $(STAGING_DIR)/usr/lib/libdirectfb.so
	cp -dpf $(STAGING_DIR)/usr/lib/libdirect* $(STAGING_DIR)/usr/lib/libfusion* $(TARGET_DIR)/usr/lib/
	cp -rdpf $(STAGING_DIR)/usr/lib/directfb-* $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded \
		$(TARGET_DIR)/usr/lib/libdirectfb.so \
		$(TARGET_DIR)/usr/lib/libdirect.so \
		$(TARGET_DIR)/usr/lib/libfusion.so

directfb: uclibc jpeg libpng freetype libsysfs $(TARGET_DIR)/usr/lib/libdirectfb.so

directfb-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(DIRECTFB_DIR) uninstall
	-$(MAKE) -C $(DIRECTFB_DIR) clean

directfb-dirclean:
	rm -rf $(DIRECTFB_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DIRECTFB)),y)
TARGETS+=directfb
endif
