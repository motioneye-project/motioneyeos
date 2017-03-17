################################################################################
#
# raspberrypi-usbboot
#
################################################################################

RASPBERRYPI_USBBOOT_VERSION = f4e3f0f9a3c64d846ba53ec3367e33a4f9a7d051
RASPBERRYPI_USBBOOT_SITE = $(call github,raspberrypi,usbboot,$(RASPBERRYPI_USBBOOT_VERSION))

HOST_RASPBERRYPI_USBBOOT_DEPENDENCIES = host-libusb

define HOST_RASPBERRYPI_USBBOOT_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define HOST_RASPBERRYPI_USBBOOT_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR=$(HOST_DIR) install
endef

$(eval $(host-generic-package))
