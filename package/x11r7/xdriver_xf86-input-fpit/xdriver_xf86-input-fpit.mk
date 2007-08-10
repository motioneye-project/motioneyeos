################################################################################
#
# xdriver_xf86-input-fpit -- Fujitsu Stylistic input driver
#
################################################################################

XDRIVER_XF86_INPUT_FPIT_VERSION = 1.1.0
XDRIVER_XF86_INPUT_FPIT_SOURCE = xf86-input-fpit-$(XDRIVER_XF86_INPUT_FPIT_VERSION).tar.bz2
XDRIVER_XF86_INPUT_FPIT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_FPIT_AUTORECONF = YES
XDRIVER_XF86_INPUT_FPIT_DEPENDANCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-fpit))
