################################################################################
#
# xdriver_xf86-input-vmmouse -- VMWare mouse input driver
#
################################################################################

XDRIVER_XF86_INPUT_VMMOUSE_VERSION = 12.5.1
XDRIVER_XF86_INPUT_VMMOUSE_SOURCE = xf86-input-vmmouse-$(XDRIVER_XF86_INPUT_VMMOUSE_VERSION).tar.bz2
XDRIVER_XF86_INPUT_VMMOUSE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_VMMOUSE_AUTORECONF = NO
XDRIVER_XF86_INPUT_VMMOUSE_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_VMMOUSE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-vmmouse))
