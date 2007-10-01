#############################################################
#
# libusb
#
#############################################################
LIBUSB_VERSION:=0.1.12
LIBUSB_PATCH_FILE:=libusb_$(LIBUSB_VERSION)-7.diff.gz
LIBUSB_SOURCE:=libusb_$(LIBUSB_VERSION).orig.tar.gz
#LIBUSB_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libusb/
LIBUSB_SITE:=http://ftp.debian.org/debian/pool/main/libu/libusb
LIBUSB_DIR:=$(BUILD_DIR)/libusb-$(LIBUSB_VERSION)
LIBUSB_CAT:=$(ZCAT)
LIBUSB_BINARY:=usr/lib/libusb.so

ifneq ($(LIBUSB_PATCH_FILE),)
LIBUSB_PATCH=$(DL_DIR)/$(LIBUSB_PATCH_FILE)
$(LIBUSB_PATCH):
	$(WGET) -P $(DL_DIR) $(LIBUSB_SITE)/$(LIBUSB_PATCH_FILE)
endif
$(DL_DIR)/$(LIBUSB_SOURCE): $(LIBUSB_PATCH)
	$(WGET) -P $(DL_DIR) $(LIBUSB_SITE)/$(LIBUSB_SOURCE)
	touch -c $@

libusb-source: $(DL_DIR)/$(LIBUSB_SOURCE) $(LIBUSB_PATCH)

libusb-unpacked: $(LIBUSB_DIR)/.unpacked
$(LIBUSB_DIR)/.unpacked: $(DL_DIR)/$(LIBUSB_SOURCE)
	$(LIBUSB_CAT) $(DL_DIR)/$(LIBUSB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(LIBUSB_PATCH_FILE),)
	(cd $(LIBUSB_DIR) && $(LIBUSB_CAT) $(LIBUSB_PATCH) | patch -p1)
endif
	toolchain/patch-kernel.sh $(LIBUSB_DIR) package/libusb/ libusb-$(LIBUSB_VERSION)\*.patch*
	$(SED) 's,^all:.*,all:,g' $(LIBUSB_DIR)/tests/Makefile.in
	$(SED) 's,^install:.*,install:,g' $(LIBUSB_DIR)/tests/Makefile.in
	touch $@

$(LIBUSB_DIR)/.configured: $(LIBUSB_DIR)/.unpacked
	(cd $(LIBUSB_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_header_regex_h=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--disable-debug \
		--disable-build-docs \
	)
	touch $@

$(STAGING_DIR)/lib/libusb.so: $(LIBUSB_DIR)/.configured
	$(MAKE) -C $(LIBUSB_DIR)
	$(MAKE) -C $(LIBUSB_DIR) DESTDIR=$(STAGING_DIR) install

$(TARGET_DIR)/$(LIBUSB_BINARY): $(STAGING_DIR)/lib/libusb.so
	$(INSTALL) -D $(LIBUSB_DIR)/.libs/libusb*.so* $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D $(LIBUSB_DIR)/.libs/libusb*.so* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libusb*.so*

libusb: uclibc $(TARGET_DIR)/$(LIBUSB_BINARY)

libusb-clean:
	rm -f $(STAGING_DIR)/bin/libusb-config
	rm -f $(STAGING_DIR)/usr/includes/usb*.h
	rm -f $(STAGING_DIR)/lib/libusb*
	rm -rf $(STAGING_DIR)/lib/pkgconfig
	rm -f $(TARGET_DIR)/usr/lib/libusb*
	-$(MAKE) -C $(LIBUSB_DIR) clean

libusb-dirclean:
	rm -rf $(LIBUSB_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBUSB)),y)
TARGETS+=libusb
endif
