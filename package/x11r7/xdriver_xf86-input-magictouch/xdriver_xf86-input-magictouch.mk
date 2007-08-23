################################################################################
#
# xdriver_xf86-input-magictouch -- MagicTouch input driver
#
################################################################################

XDRIVER_XF86_INPUT_MAGICTOUCH_VERSION = 1.0.0.5
XDRIVER_XF86_INPUT_MAGICTOUCH_SOURCE = xf86-input-magictouch-$(XDRIVER_XF86_INPUT_MAGICTOUCH_VERSION).tar.bz2
XDRIVER_XF86_INPUT_MAGICTOUCH_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_MAGICTOUCH_AUTORECONF = YES
XDRIVER_XF86_INPUT_MAGICTOUCH_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-magictouch))
