################################################################################
#
# imx-usb-loader
#
################################################################################

IMX_USB_LOADER_VERSION = 4aa9809099dcece9a9225776321f3b4b5b896d78

IMX_USB_LOADER_SITE = $(call github,boundarydevices,imx_usb_loader,$(IMX_USB_LOADER_VERSION))
IMX_USB_LOADER_LICENSE = LGPL-2.1+
IMX_USB_LOADER_LICENSE_FILES = COPYING
IMX_USB_LOADER_DEPENDENCIES = libusb host-pkgconf
HOST_IMX_USB_LOADER_DEPENDENCIES = host-libusb host-pkgconf

define IMX_USB_LOADER_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_IMX_USB_LOADER_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define IMX_USB_LOADER_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) prefix=$(TARGET_DIR)/usr install
endef

define HOST_IMX_USB_LOADER_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) prefix=$(HOST_DIR) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
