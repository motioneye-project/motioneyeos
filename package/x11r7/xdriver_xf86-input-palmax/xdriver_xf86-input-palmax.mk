################################################################################
#
# xdriver_xf86-input-palmax -- Palmax (TR88L803) touchscreen driver
#
################################################################################

XDRIVER_XF86_INPUT_PALMAX_VERSION = 1.1.0
XDRIVER_XF86_INPUT_PALMAX_SOURCE = xf86-input-palmax-$(XDRIVER_XF86_INPUT_PALMAX_VERSION).tar.bz2
XDRIVER_XF86_INPUT_PALMAX_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_PALMAX_AUTORECONF = YES
XDRIVER_XF86_INPUT_PALMAX_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-palmax))
