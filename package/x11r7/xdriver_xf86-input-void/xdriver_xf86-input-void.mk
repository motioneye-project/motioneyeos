################################################################################
#
# xdriver_xf86-input-void -- null input driver
#
################################################################################

XDRIVER_XF86_INPUT_VOID_VERSION = 1.1.0
XDRIVER_XF86_INPUT_VOID_SOURCE = xf86-input-void-$(XDRIVER_XF86_INPUT_VOID_VERSION).tar.bz2
XDRIVER_XF86_INPUT_VOID_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_VOID_AUTORECONF = YES
XDRIVER_XF86_INPUT_VOID_DEPENDANCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-void))
