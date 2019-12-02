################################################################################
#
# libgudev
#
################################################################################

LIBGUDEV_VERSION = 233
LIBGUDEV_SOURCE = libgudev-$(LIBGUDEV_VERSION).tar.xz
LIBGUDEV_SITE = http://ftp.gnome.org/pub/GNOME/sources/libgudev/$(LIBGUDEV_VERSION)
LIBGUDEV_INSTALL_STAGING = YES
LIBGUDEV_DEPENDENCIES = host-pkgconf udev libglib2
LIBGUDEV_LICENSE = LGPL-2.1+
LIBGUDEV_LICENSE_FILES = COPYING
LIBGUDEV_CONF_OPTS = --disable-umockdev

$(eval $(autotools-package))
