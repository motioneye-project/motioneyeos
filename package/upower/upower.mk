################################################################################
#
# upower
#
################################################################################

UPOWER_VERSION = 0.99.4
UPOWER_SOURCE = upower-$(UPOWER_VERSION).tar.xz
UPOWER_SITE = https://upower.freedesktop.org/releases
UPOWER_LICENSE = GPLv2+
UPOWER_LICENSE_FILES = COPYING

# libupower-glib.so
UPOWER_INSTALL_STAGING = YES

UPOWER_DEPENDENCIES = \
	host-intltool \
	host-pkgconf \
	libgudev \
	libusb \
	udev

UPOWER_CONF_OPTS = --disable-man-pages --disable-tests

$(eval $(autotools-package))
