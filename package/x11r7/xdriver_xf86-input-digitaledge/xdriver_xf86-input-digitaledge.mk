################################################################################
#
# xdriver_xf86-input-digitaledge -- X.Org driver for digitaledge input devices
#
################################################################################

XDRIVER_XF86_INPUT_DIGITALEDGE_VERSION = 1.1.0
XDRIVER_XF86_INPUT_DIGITALEDGE_SOURCE = xf86-input-digitaledge-$(XDRIVER_XF86_INPUT_DIGITALEDGE_VERSION).tar.bz2
XDRIVER_XF86_INPUT_DIGITALEDGE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_DIGITALEDGE_AUTORECONF = NO
XDRIVER_XF86_INPUT_DIGITALEDGE_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-digitaledge))
