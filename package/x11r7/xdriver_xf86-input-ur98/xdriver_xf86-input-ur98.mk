################################################################################
#
# xdriver_xf86-input-ur98 -- UR98 (TR88L803) head tracker driver
#
################################################################################

XDRIVER_XF86_INPUT_UR98_VERSION = 1.1.0
XDRIVER_XF86_INPUT_UR98_SOURCE = xf86-input-ur98-$(XDRIVER_XF86_INPUT_UR98_VERSION).tar.bz2
XDRIVER_XF86_INPUT_UR98_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_UR98_AUTORECONF = YES
XDRIVER_XF86_INPUT_UR98_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-ur98))
