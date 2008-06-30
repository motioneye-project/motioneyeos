################################################################################
#
# xdriver_xf86-input-fpit -- Fujitsu Stylistic input driver
#
################################################################################

XDRIVER_XF86_INPUT_FPIT_VERSION = 1.2.0
XDRIVER_XF86_INPUT_FPIT_SOURCE = xf86-input-fpit-$(XDRIVER_XF86_INPUT_FPIT_VERSION).tar.bz2
XDRIVER_XF86_INPUT_FPIT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_FPIT_AUTORECONF = NO
XDRIVER_XF86_INPUT_FPIT_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_FPIT_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-fpit))
