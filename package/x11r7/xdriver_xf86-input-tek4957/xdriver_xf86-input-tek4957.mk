################################################################################
#
# xdriver_xf86-input-tek4957 -- Tektronix 4957 input driver
#
################################################################################

XDRIVER_XF86_INPUT_TEK4957_VERSION = 1.2.0
XDRIVER_XF86_INPUT_TEK4957_SOURCE = xf86-input-tek4957-$(XDRIVER_XF86_INPUT_TEK4957_VERSION).tar.bz2
XDRIVER_XF86_INPUT_TEK4957_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_TEK4957_AUTORECONF = NO
XDRIVER_XF86_INPUT_TEK4957_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-tek4957))
