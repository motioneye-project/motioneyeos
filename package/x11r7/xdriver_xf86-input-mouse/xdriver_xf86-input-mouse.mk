################################################################################
#
# xdriver_xf86-input-mouse -- X.Org driver for mouse input devices
#
################################################################################

XDRIVER_XF86_INPUT_MOUSE_VERSION = 1.1.2
XDRIVER_XF86_INPUT_MOUSE_SOURCE = xf86-input-mouse-$(XDRIVER_XF86_INPUT_MOUSE_VERSION).tar.bz2
XDRIVER_XF86_INPUT_MOUSE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_MOUSE_AUTORECONF = YES
XDRIVER_XF86_INPUT_MOUSE_DEPENDANCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-mouse))
