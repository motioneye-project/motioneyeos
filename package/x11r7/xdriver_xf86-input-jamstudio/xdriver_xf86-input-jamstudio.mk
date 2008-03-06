################################################################################
#
# xdriver_xf86-input-jamstudio -- X.Org driver for jamstudio input devices
#
################################################################################

XDRIVER_XF86_INPUT_JAMSTUDIO_VERSION = 1.1.0
XDRIVER_XF86_INPUT_JAMSTUDIO_SOURCE = xf86-input-jamstudio-$(XDRIVER_XF86_INPUT_JAMSTUDIO_VERSION).tar.bz2
XDRIVER_XF86_INPUT_JAMSTUDIO_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_JAMSTUDIO_AUTORECONF = NO
XDRIVER_XF86_INPUT_JAMSTUDIO_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-jamstudio))
