################################################################################
#
# pcsc-lite
#
################################################################################

PCSC_LITE_VERSION = 1.8.22
PCSC_LITE_SOURCE = pcsc-lite-$(PCSC_LITE_VERSION).tar.bz2
PCSC_LITE_SITE = http://alioth.debian.org/frs/download.php/file/4203
PCSC_LITE_INSTALL_STAGING = YES
PCSC_LITE_DEPENDENCIES = host-pkgconf
PCSC_LITE_LICENSE = BSD-3-Clause
PCSC_LITE_LICENSE_FILES = COPYING
PCSC_LITE_AUTORECONF = YES

# - libudev and libusb are optional
# - libudev and libusb can't be used together
# - libudev has a priority over libusb

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
PCSC_LITE_CONF_OPTS += --enable-libudev --disable-libusb
PCSC_LITE_DEPENDENCIES += udev
else
ifeq ($(BR2_PACKAGE_LIBUSB),y)
PCSC_LITE_CONF_OPTS += --enable-libusb --disable-libudev
PCSC_LITE_DEPENDENCIES += libusb
else
PCSC_LITE_CONF_OPTS += --disable-libusb --disable-libudev
endif
endif

ifeq ($(PACKAGE_PCSC_LITE_DEBUGATR),y)
PCSC_LITE_CONF_OPTS += --enable-debugatr
endif

ifeq ($(PACKAGE_PCSC_LITE_EMBEDDED),y)
PCSC_LITE_CONF_OPTS += --enable-embedded
endif

define PCSC_LITE_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sockets.target.wants
	ln -sf ../../../../usr/lib/systemd/system/pcscd.socket \
		$(TARGET_DIR)/etc/systemd/system/sockets.target.wants/pcscd.socket
endef

$(eval $(autotools-package))
