#############################################################
#
# directfb
#
#############################################################
DIRECTFB_VERSION:=0.9.22
DIRECTFB_SOURCE:=DirectFB-$(DIRECTFB_VERSION).tar.gz
DIRECTFB_SITE:=http://www.directfb.org/downloads/Core
DIRECTFB_CAT:=zcat
DIRECTFB_DIR:=$(BUILD_DIR)/DirectFB-$(DIRECTFB_VERSION)

$(DL_DIR)/$(DIRECTFB_SOURCE):
	$(WGET) -P $(DL_DIR) $(DIRECTFB_SITE)/$(DIRECTFB_SOURCE)

directfb-source: $(DL_DIR)/$(DIRECTFB_SOURCE)

$(DIRECTFB_DIR)/.unpacked: $(DL_DIR)/$(DIRECTFB_SOURCE)
	$(DIRECTFB_CAT) $(DL_DIR)/$(DIRECTFB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(DIRECTFB_DIR)/.unpacked

$(DIRECTFB_DIR)/.configured: $(DIRECTFB_DIR)/.unpacked
	(cd $(DIRECTFB_DIR); \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include" \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--prefix=/usr \
	--with-gfxdrivers=cle266,unichrome \
	--enable-jpeg \
	--enable-png \
	--enable-linux-input \
	--enable-zlib \
	--enable-freetype \
	--enable-sysfs \
	--disable-video4linux \
	--disable-video4linux2 \
	--disable-fusion );
	touch  $(DIRECTFB_DIR)/.configured

$(DIRECTFB_DIR)/.compiled: $(DIRECTFB_DIR)/.configured
	$(MAKE) -C $(DIRECTFB_DIR) \
	LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib" \
	INCLS="-I. -I$(STAGING_DIR)/include"
	touch $(DIRECTFB_DIR)/.compiled

$(STAGING_DIR)/usr/lib/libdirectfb.so: $(DIRECTFB_DIR)/.compiled
	$(MAKE) -C $(DIRECTFB_DIR) DESTDIR=$(STAGING_DIR) install
	touch -c $(STAGING_DIR)/lib/libdirectfb.so

$(TARGET_DIR)/usr/lib/libdirectfb.so: $(STAGING_DIR)/usr/lib/libdirectfb.so
	cp -dpf $(STAGING_DIR)/usr/lib/libdirectfb* $(TARGET_DIR)/usr/lib/
	cp -rdpf $(STAGING_DIR)/usr/lib/directfb-$(DIRECTFB_VERSION) $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libdirectfb.so

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
