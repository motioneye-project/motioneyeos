################################################################################
#
# xdriver_xf86-input-magellan -- X.Org driver for magellan input devices
#
################################################################################

XDRIVER_XF86_INPUT_MAGELLAN_VERSION = 1.1.0
XDRIVER_XF86_INPUT_MAGELLAN_SOURCE = xf86-input-magellan-$(XDRIVER_XF86_INPUT_MAGELLAN_VERSION).tar.bz2
XDRIVER_XF86_INPUT_MAGELLAN_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_MAGELLAN_AUTORECONF = YES
XDRIVER_XF86_INPUT_MAGELLAN_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-magellan))
