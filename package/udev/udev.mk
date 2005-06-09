#############################################################
#
# udev
#
#############################################################
UDEV_VERSION:=058
UDEV_SOURCE:=udev-$(UDEV_VERSION).tar.bz2
UDEV_SITE:=ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug/
UDEV_CAT:=bzcat
UDEV_DIR:=$(BUILD_DIR)/udev-$(UDEV_VERSION)
UDEV_TARGET_BINARY:=sbin/udev
UDEV_BINARY:=udev

# UDEV_ROOT is /dev so we can replace devfs, not /udev for experiments
UDEV_ROOT:=/dev

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
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR)
	touch -c $(UDEV_DIR)/$(UDEV_BINARY)

# UDEV_CONF overrides default policies for device access control and naming;
# default access controls prevent non-root tasks from running.  Many of the
# rule files rely on PROGRAM invocations (e.g. extra /etc/udev/scripts);
# for now we'll avoid having buildroot systems rely on them.
UDEV_CONF:=etc/udev/frugalware/udev.rules

$(TARGET_DIR)/$(UDEV_TARGET_BINARY): $(UDEV_DIR)/$(UDEV_BINARY)
	-mkdir $(TARGET_DIR)/sys
	install -D -m 0644 $(UDEV_DIR)/$(UDEV_CONF) \
		$(TARGET_DIR)/etc/udev/rules.d/50-udev.rules
	$(MAKE) CROSS=$(TARGET_CROSS) GCC=$(TARGET_CC) DESTDIR=$(TARGET_DIR) \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR) install
	$(INSTALL) -m 0755 -D package/udev/init-udev $(TARGET_DIR)/etc/init.d/S10udev

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
