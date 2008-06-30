################################################################################
#
# xdriver_xf86-input-elo2300 -- X.Org driver for elo2300 input devices
#
################################################################################

XDRIVER_XF86_INPUT_ELO2300_VERSION = 1.1.2
XDRIVER_XF86_INPUT_ELO2300_SOURCE = xf86-input-elo2300-$(XDRIVER_XF86_INPUT_ELO2300_VERSION).tar.bz2
XDRIVER_XF86_INPUT_ELO2300_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_ELO2300_AUTORECONF = NO
XDRIVER_XF86_INPUT_ELO2300_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_ELO2300_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-elo2300))
