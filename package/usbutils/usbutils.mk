#############################################################
#
# usbutils
#
#############################################################
USBUTILS_VERSION:=0.72
USBUTILS_SOURCE:=usbutils-$(USBUTILS_VERSION).tar.gz
USBUTILS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/linux-usb/
USBUTILS_DIR:=$(BUILD_DIR)/usbutils-$(USBUTILS_VERSION)
USBUTILS_CAT:=$(ZCAT)
USBUTILS_BINARY:=lsusb
USBUTILS_TARGET_BINARY:=usr/sbin/lsusb

$(DL_DIR)/$(USBUTILS_SOURCE):
	$(WGET) -P $(DL_DIR) $(USBUTILS_SITE)/$(USBUTILS_SOURCE)

usbutils-source: $(DL_DIR)/$(USBUTILS_SOURCE)

usbutils-unpacked: $(USBUTILS_DIR)/.unpacked
$(USBUTILS_DIR)/.unpacked: $(DL_DIR)/$(USBUTILS_SOURCE)
	$(USBUTILS_CAT) $(DL_DIR)/$(USBUTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(USBUTILS_DIR)/.unpacked

$(USBUTILS_DIR)/.configured: $(USBUTILS_DIR)/.unpacked
	(cd $(USBUTILS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_func_malloc_0_nonnull=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
	)
	touch $(USBUTILS_DIR)/.configured

$(USBUTILS_DIR)/$(USBUTILS_BINARY): $(USBUTILS_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(USBUTILS_DIR)

$(TARGET_DIR)/$(USBUTILS_TARGET_BINARY): $(USBUTILS_DIR)/$(USBUTILS_BINARY)
	$(MAKE) -C $(USBUTILS_DIR) DESTDIR=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/usr/man

usbutils: uclibc libusb $(TARGET_DIR)/$(USBUTILS_TARGET_BINARY)

usbutils-clean:
	rm -f $(TARGET_DIR)/$(USBUTILS_TARGET_BINARY)
	rm -f $(TARGET_DIR)/usr/share/usb.ids
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share
	-$(MAKE) -C $(USBUTILS_DIR) clean

usbutils-dirclean:
	rm -rf $(USBUTILS_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_USBUTILS)),y)
TARGETS+=usbutils
endif
