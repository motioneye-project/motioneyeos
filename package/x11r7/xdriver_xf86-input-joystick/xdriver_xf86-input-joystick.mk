################################################################################
#
# xdriver_xf86-input-joystick
#
################################################################################

XDRIVER_XF86_INPUT_JOYSTICK_VERSION = 1.6.1
XDRIVER_XF86_INPUT_JOYSTICK_SOURCE = xf86-input-joystick-$(XDRIVER_XF86_INPUT_JOYSTICK_VERSION).tar.bz2
XDRIVER_XF86_INPUT_JOYSTICK_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_JOYSTICK_LICENSE = MIT
XDRIVER_XF86_INPUT_JOYSTICK_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_JOYSTICK_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(autotools-package))
