################################################################################
#
# xdriver_xf86-input-vmmouse
#
################################################################################

XDRIVER_XF86_INPUT_VMMOUSE_VERSION = 13.1.0
XDRIVER_XF86_INPUT_VMMOUSE_SOURCE = xf86-input-vmmouse-$(XDRIVER_XF86_INPUT_VMMOUSE_VERSION).tar.bz2
XDRIVER_XF86_INPUT_VMMOUSE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_VMMOUSE_LICENSE = MIT
XDRIVER_XF86_INPUT_VMMOUSE_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_VMMOUSE_DEPENDENCIES = xserver_xorg-server xorgproto

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
XDRIVER_XF86_INPUT_VMMOUSE_CONF_OPTS += --with-libudev
XDRIVER_XF86_INPUT_VMMOUSE_DEPENDENCIES += udev
else
XDRIVER_XF86_INPUT_VMMOUSE_CONF_OPTS += --without-libudev
endif

$(eval $(autotools-package))
