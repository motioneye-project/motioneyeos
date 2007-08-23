################################################################################
#
# xdriver_xf86-input-dynapro -- Dynapro input driver
#
################################################################################

XDRIVER_XF86_INPUT_DYNAPRO_VERSION = 1.1.0
XDRIVER_XF86_INPUT_DYNAPRO_SOURCE = xf86-input-dynapro-$(XDRIVER_XF86_INPUT_DYNAPRO_VERSION).tar.bz2
XDRIVER_XF86_INPUT_DYNAPRO_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_DYNAPRO_AUTORECONF = YES
XDRIVER_XF86_INPUT_DYNAPRO_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-dynapro))
