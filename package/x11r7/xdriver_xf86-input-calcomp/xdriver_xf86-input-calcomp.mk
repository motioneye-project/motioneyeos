################################################################################
#
# xdriver_xf86-input-calcomp -- Calcomp input driver
#
################################################################################

XDRIVER_XF86_INPUT_CALCOMP_VERSION = 1.1.0
XDRIVER_XF86_INPUT_CALCOMP_SOURCE = xf86-input-calcomp-$(XDRIVER_XF86_INPUT_CALCOMP_VERSION).tar.bz2
XDRIVER_XF86_INPUT_CALCOMP_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_CALCOMP_AUTORECONF = YES
XDRIVER_XF86_INPUT_CALCOMP_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-calcomp))
