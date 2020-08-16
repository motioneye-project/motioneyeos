################################################################################
#
# usb_modeswitch
#
################################################################################

USB_MODESWITCH_VERSION = 2.6.0
USB_MODESWITCH_SOURCE = usb-modeswitch-$(USB_MODESWITCH_VERSION).tar.bz2
USB_MODESWITCH_SITE = http://www.draisberghof.de/usb_modeswitch
USB_MODESWITCH_DEPENDENCIES = libusb
USB_MODESWITCH_LICENSE = GPL-2.0+, BSD-2-Clause
USB_MODESWITCH_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_TCL)$(BR2_PACKAGE_TCL_SHLIB_ONLY),y)
USB_MODESWITCH_DEPENDENCIES += tcl
USB_MODESWITCH_BUILD_TARGETS = all
USB_MODESWITCH_INSTALL_TARGETS = install-script
else
USB_MODESWITCH_DEPENDENCIES += jimtcl
ifeq ($(BR2_STATIC_LIBS),y)
USB_MODESWITCH_BUILD_TARGETS = all-with-statlink-dispatcher
USB_MODESWITCH_INSTALL_TARGETS = install-statlink
else
USB_MODESWITCH_BUILD_TARGETS = all-with-dynlink-dispatcher
USB_MODESWITCH_INSTALL_TARGETS = install-dynlink
endif
endif

define USB_MODESWITCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		-C $(@D) $(USB_MODESWITCH_BUILD_TARGETS)
endef

define USB_MODESWITCH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(TARGET_DIR) \
		-C $(@D) $(USB_MODESWITCH_INSTALL_TARGETS)
endef

$(eval $(generic-package))
