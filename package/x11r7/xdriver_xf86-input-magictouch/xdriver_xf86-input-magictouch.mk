################################################################################
#
# xdriver_xf86-input-magictouch -- MagicTouch input driver
#
################################################################################

XDRIVER_XF86_INPUT_MAGICTOUCH_VERSION = 1.0.0.5
XDRIVER_XF86_INPUT_MAGICTOUCH_SOURCE = xf86-input-magictouch-$(XDRIVER_XF86_INPUT_MAGICTOUCH_VERSION).tar.bz2
XDRIVER_XF86_INPUT_MAGICTOUCH_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_MAGICTOUCH_AUTORECONF = NO
XDRIVER_XF86_INPUT_MAGICTOUCH_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_MAGICTOUCH_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-magictouch))
