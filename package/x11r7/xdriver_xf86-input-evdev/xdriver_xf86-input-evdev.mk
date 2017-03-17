################################################################################
#
# xdriver_xf86-input-evdev
#
################################################################################

XDRIVER_XF86_INPUT_EVDEV_VERSION = 2.10.5
XDRIVER_XF86_INPUT_EVDEV_SOURCE = xf86-input-evdev-$(XDRIVER_XF86_INPUT_EVDEV_VERSION).tar.bz2
XDRIVER_XF86_INPUT_EVDEV_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_EVDEV_LICENSE = MIT
XDRIVER_XF86_INPUT_EVDEV_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_EVDEV_AUTORECONF = YES

XDRIVER_XF86_INPUT_EVDEV_DEPENDENCIES = \
	host-pkgconf \
	libevdev \
	mtdev \
	xproto_inputproto \
	xserver_xorg-server \
	xproto_randrproto \
	xproto_xproto \
	udev

$(eval $(autotools-package))
