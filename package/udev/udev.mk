#############################################################
#
# udev
#
#############################################################
UDEV_VERSION:=100
UDEV_SOURCE:=udev-$(UDEV_VERSION).tar.bz2
UDEV_SITE:=ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug/
UDEV_CAT:=$(BZCAT)
UDEV_DIR:=$(BUILD_DIR)/udev-$(UDEV_VERSION)
UDEV_TARGET_BINARY:=sbin/udev
UDEV_BINARY:=udev

# 094 had _GNU_SOURCE set
BR2_UDEV_CFLAGS:= -D_GNU_SOURCE $(TARGET_CFLAGS)
ifeq ($(BR2_LARGEFILE),)
BR2_UDEV_CFLAGS+=-U_FILE_OFFSET_BITS
endif


# UDEV_ROOT is /dev so we can replace devfs, not /udev for experiments
UDEV_ROOT:=/dev

$(DL_DIR)/$(UDEV_SOURCE):
	 $(WGET) -P $(DL_DIR) $(UDEV_SITE)/$(UDEV_SOURCE)

udev-source: $(DL_DIR)/$(UDEV_SOURCE)

$(UDEV_DIR)/.unpacked: $(DL_DIR)/$(UDEV_SOURCE)
	$(UDEV_CAT) $(DL_DIR)/$(UDEV_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(UDEV_DIR) package/udev \*.patch
	touch $(UDEV_DIR)/.unpacked

$(UDEV_DIR)/.configured: $(UDEV_DIR)/.unpacked
	touch $(UDEV_DIR)/.configured

$(UDEV_DIR)/$(UDEV_BINARY): $(UDEV_DIR)/.configured
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) CC=$(TARGET_CC) LD=$(TARGET_CC)\
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR)
	touch -c $(UDEV_DIR)/$(UDEV_BINARY)

# UDEV_CONF overrides default policies for device access control and naming;
# default access controls prevent non-root tasks from running.  Many of the
# rule files rely on PROGRAM invocations (e.g. extra /etc/udev/scripts);
# for now we'll avoid having buildroot systems rely on them.
UDEV_CONF:=etc/udev/frugalware/*

$(TARGET_DIR)/$(UDEV_TARGET_BINARY): $(UDEV_DIR)/$(UDEV_BINARY)
	-mkdir $(TARGET_DIR)/sys
	-mkdir $(TARGET_DIR)/etc/udev/rules.d
	$(INSTALL) -D -m 0644 $(UDEV_DIR)/$(UDEV_CONF) \
		$(TARGET_DIR)/etc/udev/rules.d
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) CC=$(TARGET_CC)  LD=$(TARGET_CC) \
		DESTDIR=$(TARGET_DIR) \
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		LDFLAGS="-warn-common" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR) install
	$(INSTALL) -m 0755 -D package/udev/init-udev $(TARGET_DIR)/etc/init.d/S10udev
	$(INSTALL) -m 0644 -D package/udev/udev.conf $(TARGET_DIR)/etc/udev

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
