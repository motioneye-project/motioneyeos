#############################################################
#
# udev
#
#############################################################
UDEV_VERSION:=030
UDEV_SOURCE:=udev-$(UDEV_VERSION).tar.bz2
UDEV_SITE:=ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug/
UDEV_CAT:=bzcat
UDEV_DIR:=$(BUILD_DIR)/udev-$(UDEV_VERSION)
UDEV_TARGET_BINARY:=sbin/udev
UDEV_BINARY:=udev

$(DL_DIR)/$(UDEV_SOURCE):
	 $(WGET) -P $(DL_DIR) $(UDEV_SITE)/$(UDEV_SOURCE)

udev-source: $(DL_DIR)/$(UDEV_SOURCE)

$(UDEV_DIR)/.unpacked: $(DL_DIR)/$(UDEV_SOURCE)
	$(UDEV_CAT) $(DL_DIR)/$(UDEV_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(UDEV_DIR)/.unpacked

$(UDEV_DIR)/.configured: $(UDEV_DIR)/.unpacked
	touch  $(UDEV_DIR)/.configured

$(UDEV_DIR)/$(UDEV_BINARY): $(UDEV_DIR)/.configured
	$(MAKE) CROSS=$(TARGET_CROSS) GCC=$(TARGET_CC) \
		USE_LOG=false USE_SELINUX=false -C $(UDEV_DIR)
	touch -c $(UDEV_DIR)/$(UDEV_BINARY)

$(TARGET_DIR)/$(UDEV_TARGET_BINARY): $(UDEV_DIR)/$(UDEV_BINARY)
	$(MAKE) CROSS=$(TARGET_CROSS) GCC=$(TARGET_CC) DESTDIR=$(TARGET_DIR) \
		USE_LOG=false USE_SELINUX=false -C $(UDEV_DIR) install

udev: uclibc $(TARGET_DIR)/$(UDEV_TARGET_BINARY)

udev-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(UDEV_DIR) uninstall
	-$(MAKE) -C $(UDEV_DIR) clean

udev-dirclean:
	rm -rf $(UDEV_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_UDEV)),y)
TARGETS+=udev
endif
