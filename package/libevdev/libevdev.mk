################################################################################
#
# libevdev
#
################################################################################

LIBEVDEV_VERSION = 1.4.3
LIBEVDEV_SITE = http://www.freedesktop.org/software/libevdev
LIBEVDEV_SOURCE = libevdev-$(LIBEVDEV_VERSION).tar.xz
LIBEVDEV_LICENSE = X11
LIBEVDEV_LICENSE_FILES = COPYING

# Uses PKG_CHECK_MODULES() in configure.ac
LIBEVDEV_DEPENDENCIES = host-pkgconf

LIBEVDEV_INSTALL_STAGING = YES

$(eval $(autotools-package))
