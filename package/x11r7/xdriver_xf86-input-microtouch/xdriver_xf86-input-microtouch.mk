################################################################################
#
# xdriver_xf86-input-microtouch -- MicroTouch input driver
#
################################################################################

XDRIVER_XF86_INPUT_MICROTOUCH_VERSION = 1.1.0
XDRIVER_XF86_INPUT_MICROTOUCH_SOURCE = xf86-input-microtouch-$(XDRIVER_XF86_INPUT_MICROTOUCH_VERSION).tar.bz2
XDRIVER_XF86_INPUT_MICROTOUCH_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_MICROTOUCH_AUTORECONF = YES
XDRIVER_XF86_INPUT_MICROTOUCH_DEPENDANCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-input-microtouch))
