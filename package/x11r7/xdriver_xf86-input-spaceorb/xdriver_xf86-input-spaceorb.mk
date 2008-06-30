################################################################################
#
# xdriver_xf86-input-spaceorb -- X.Org driver for spaceorb input devices
#
################################################################################

XDRIVER_XF86_INPUT_SPACEORB_VERSION = 1.1.1
XDRIVER_XF86_INPUT_SPACEORB_SOURCE = xf86-input-spaceorb-$(XDRIVER_XF86_INPUT_SPACEORB_VERSION).tar.bz2
XDRIVER_XF86_INPUT_SPACEORB_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_SPACEORB_AUTORECONF = NO
XDRIVER_XF86_INPUT_SPACEORB_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_SPACEORB_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-spaceorb))
