#############################################################
#
# libusb
#
#############################################################
LIBUSB_VERSION:=0.1.12
LIBUSB_SOURCE:=libusb-$(LIBUSB_VERSION).tar.gz
LIBUSB_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libusb/
LIBUSB_DIR:=$(BUILD_DIR)/libusb-$(LIBUSB_VERSION)
LIBUSB_CAT:=$(ZCAT)
LIBUSB_BINARY:=usr/lib/libusb.so

$(DL_DIR)/$(LIBUSB_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBUSB_SITE)/$(LIBUSB_SOURCE)

libusb-source: $(DL_DIR)/$(LIBUSB_SOURCE)

libusb-unpacked: $(LIBUSB_DIR)/.unpacked
$(LIBUSB_DIR)/.unpacked: $(DL_DIR)/$(LIBUSB_SOURCE)
	$(LIBUSB_CAT) $(DL_DIR)/$(LIBUSB_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBUSB_DIR)/.unpacked

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
	);
	touch $(LIBUSB_DIR)/.configured

$(STAGING_DIR)/lib/libusb.so: $(LIBUSB_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(LIBUSB_DIR)
	$(MAKE) -C $(LIBUSB_DIR) DESTDIR=$(STAGING_DIR) install

$(TARGET_DIR)/$(LIBUSB_BINARY): $(STAGING_DIR)/lib/libusb.so
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -a $(STAGING_DIR)/lib/libusb* $(TARGET_DIR)/usr/lib
	rm -f $(TARGET_DIR)/usr/lib/*.a $(TARGET_DIR)/usr/lib/*.la

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

.PHONY: libusb

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBUSB)),y)
TARGETS+=libusb
endif
