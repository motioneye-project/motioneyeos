################################################################################
#
# xdriver_xf86-input-elographics -- Elographics input driver
#
################################################################################

XDRIVER_XF86_INPUT_ELOGRAPHICS_VERSION = 1.2.1
XDRIVER_XF86_INPUT_ELOGRAPHICS_SOURCE = xf86-input-elographics-$(XDRIVER_XF86_INPUT_ELOGRAPHICS_VERSION).tar.bz2
XDRIVER_XF86_INPUT_ELOGRAPHICS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_ELOGRAPHICS_AUTORECONF = NO
XDRIVER_XF86_INPUT_ELOGRAPHICS_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-elographics))
