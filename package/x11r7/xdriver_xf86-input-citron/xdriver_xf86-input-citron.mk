################################################################################
#
# xdriver_xf86-input-citron -- X.Org driver for citron input devices
#
################################################################################

XDRIVER_XF86_INPUT_CITRON_VERSION = 2.2.0
XDRIVER_XF86_INPUT_CITRON_SOURCE = xf86-input-citron-$(XDRIVER_XF86_INPUT_CITRON_VERSION).tar.bz2
XDRIVER_XF86_INPUT_CITRON_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_CITRON_AUTORECONF = NO
XDRIVER_XF86_INPUT_CITRON_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-citron))
