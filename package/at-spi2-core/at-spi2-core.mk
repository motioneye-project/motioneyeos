################################################################################
#
# at-spi2-core
#
################################################################################

AT_SPI2_CORE_VERSION_MAJOR = 2.28
AT_SPI2_CORE_VERSION = $(AT_SPI2_CORE_VERSION_MAJOR).0
AT_SPI2_CORE_SOURCE = at-spi2-core-$(AT_SPI2_CORE_VERSION).tar.xz
AT_SPI2_CORE_SITE = http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/$(AT_SPI2_CORE_VERSION_MAJOR)
AT_SPI2_CORE_LICENSE = LGPL-2.0+
AT_SPI2_CORE_LICENSE_FILES = COPYING
AT_SPI2_CORE_INSTALL_STAGING = YES
AT_SPI2_CORE_DEPENDENCIES = host-pkgconf dbus libglib2 xlib_libXtst
AT_SPI2_CORE_CONF_OPTS = -Ddbus_daemon=/usr/bin/dbus-daemon

$(eval $(meson-package))
