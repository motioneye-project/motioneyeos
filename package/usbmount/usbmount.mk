#############################################################
#
# usbmount
#
#############################################################
USBMOUNT_VERSION=0.0.14.1
USBMOUNT_SOURCE:=usbmount_$(USBMOUNT_VERSION).tar.gz
USBMOUNT_SITE:=http://usbmount.alioth.debian.org/package/
USBMOUNT_CAT:=$(ZCAT)
USBMOUNT_DIR:=$(BUILD_DIR)/usbmount-$(USBMOUNT_VERSION)
USBMOUNT_BINARY:=usbmount
USBMOUNT_TARGET_BINARY:=sbin/usbmount

$(DL_DIR)/$(USBMOUNT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(USBMOUNT_SITE)/$(USBMOUNT_SOURCE)

usbmount-source: $(DL_DIR)/$(USBMOUNT_SOURCE)

$(USBMOUNT_DIR)/.unpacked: $(DL_DIR)/$(USBMOUNT_SOURCE)
	$(USBMOUNT_CAT) $(DL_DIR)/$(USBMOUNT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(USBMOUNT_DIR) package/usbmount \*.patch
	touch $@

$(TARGET_DIR)/$(USBMOUNT_TARGET_BINARY): $(USBMOUNT_DIR)/.unpacked
	$(INSTALL) -m 0755 -D $(USBMOUNT_DIR)/usbmount $(TARGET_DIR)/$(USBMOUNT_TARGET_BINARY)
	@if [ ! -f $(TARGET_DIR)/etc/usbmount/usbmount.conf ] ; then \
                $(INSTALL) -m 0644 -D $(USBMOUNT_DIR)/usbmount.conf $(TARGET_DIR)/etc/usbmount/usbmount.conf; \
        fi;

usbmount: uclibc $(TARGET_DIR)/$(USBMOUNT_TARGET_BINARY)

usbmount-clean:
	rm -f $(TARGET_DIR)/$(USBMOUNT_TARGET_BINARY)
	rm -rf $(TARGET_DIR)/etc/usbmount

usbmount-dirclean:
	rm -rf $(USBMOUNT_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_USBMOUNT)),y)
TARGETS+=usbmount
endif
