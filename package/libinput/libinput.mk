################################################################################
#
# libinput
#
################################################################################

LIBINPUT_VERSION = 1.8.2
LIBINPUT_SOURCE = libinput-$(LIBINPUT_VERSION).tar.xz
LIBINPUT_SITE = http://www.freedesktop.org/software/libinput
LIBINPUT_DEPENDENCIES = host-pkgconf libevdev mtdev udev
LIBINPUT_INSTALL_STAGING = YES
LIBINPUT_LICENSE = MIT
LIBINPUT_LICENSE_FILES = COPYING
# Tests need fork, so just disable them everywhere.
LIBINPUT_CONF_OPTS = --disable-tests --disable-libwacom

ifeq ($(BR2_PACKAGE_LIBGTK3),y)
LIBINPUT_CONF_OPTS += --enable-debug-gui
LIBINPUT_DEPENDENCIES += libgtk3
else
LIBINPUT_CONF_OPTS += --disable-debug-gui
endif

$(eval $(autotools-package))
