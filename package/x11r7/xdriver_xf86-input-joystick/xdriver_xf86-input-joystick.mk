################################################################################
#
# xdriver_xf86-input-joystick -- X.Org driver for joystick input devices
#
################################################################################

XDRIVER_XF86_INPUT_JOYSTICK_VERSION = 1.1.0
XDRIVER_XF86_INPUT_JOYSTICK_SOURCE = xf86-input-joystick-$(XDRIVER_XF86_INPUT_JOYSTICK_VERSION).tar.bz2
XDRIVER_XF86_INPUT_JOYSTICK_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_JOYSTICK_AUTORECONF = NO
XDRIVER_XF86_INPUT_JOYSTICK_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-joystick))
