################################################################################
#
# xdriver_xf86-input-magellan -- X.Org driver for magellan input devices
#
################################################################################

XDRIVER_XF86_INPUT_MAGELLAN_VERSION = 1.2.0
XDRIVER_XF86_INPUT_MAGELLAN_SOURCE = xf86-input-magellan-$(XDRIVER_XF86_INPUT_MAGELLAN_VERSION).tar.bz2
XDRIVER_XF86_INPUT_MAGELLAN_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_MAGELLAN_AUTORECONF = NO
XDRIVER_XF86_INPUT_MAGELLAN_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_MAGELLAN_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-magellan))
