################################################################################
#
# xdriver_xf86-input-dynapro -- Dynapro input driver
#
################################################################################

XDRIVER_XF86_INPUT_DYNAPRO_VERSION = 1.1.2
XDRIVER_XF86_INPUT_DYNAPRO_SOURCE = xf86-input-dynapro-$(XDRIVER_XF86_INPUT_DYNAPRO_VERSION).tar.bz2
XDRIVER_XF86_INPUT_DYNAPRO_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_DYNAPRO_AUTORECONF = NO
XDRIVER_XF86_INPUT_DYNAPRO_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_DYNAPRO_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-dynapro))
