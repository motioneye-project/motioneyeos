################################################################################
#
# imx-usb-loader
#
################################################################################

IMX_USB_LOADER_VERSION = f04f225ebc1c38e81eb24745333c8622deda6b49
IMX_USB_LOADER_SITE = $(call github,boundarydevices,imx_usb_loader,$(IMX_USB_LOADER_VERSION))
IMX_USB_LOADER_LICENSE = LGPL-2.1+
IMX_USB_LOADER_LICENSE_FILES = COPYING
HOST_IMX_USB_LOADER_DEPENDENCIES = host-libusb host-pkgconf

define HOST_IMX_USB_LOADER_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_IMX_USB_LOADER_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) prefix=$(HOST_DIR) install
endef

$(eval $(host-generic-package))
