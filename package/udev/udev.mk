#############################################################
#
# udev
#
#############################################################
UDEV_VERSION = 173
UDEV_SOURCE = udev-$(UDEV_VERSION).tar.bz2
UDEV_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kernel/hotplug/

UDEV_CONF_OPT =			\
	--sbindir=/sbin		\
	--with-rootlibdir=/lib	\
	--libexecdir=/lib/udev	\
	--disable-introspection

UDEV_DEPENDENCIES = host-gperf host-pkg-config

ifeq ($(BR2_PACKAGE_UDEV_ALL_EXTRAS),y)
UDEV_DEPENDENCIES += libusb libusb-compat acl usbutils hwdata libglib2
UDEV_CONF_OPT +=							\
	--with-pci-ids-path=$(TARGET_DIR)/usr/share/hwdata/pci.ids	\
	--with-usb-ids-path=$(TARGET_DIR)/usr/share/hwdata/usb.ids	\
	--enable-udev_acl
else
UDEV_CONF_OPT +=		\
	--disable-hwdb		\
	--disable-gudev
endif

define UDEV_INSTALL_INITSCRIPT
	$(INSTALL) -m 0755 package/udev/S10udev $(TARGET_DIR)/etc/init.d/S10udev
endef

UDEV_POST_INSTALL_TARGET_HOOKS += UDEV_INSTALL_INITSCRIPT

$(eval $(call AUTOTARGETS,package,udev))
