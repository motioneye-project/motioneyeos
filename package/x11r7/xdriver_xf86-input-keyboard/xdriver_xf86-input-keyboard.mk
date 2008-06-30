################################################################################
#
# xdriver_xf86-input-keyboard -- Keyboard input driver
#
################################################################################

XDRIVER_XF86_INPUT_KEYBOARD_VERSION = 1.3.1
XDRIVER_XF86_INPUT_KEYBOARD_SOURCE = xf86-input-keyboard-$(XDRIVER_XF86_INPUT_KEYBOARD_VERSION).tar.bz2
XDRIVER_XF86_INPUT_KEYBOARD_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_KEYBOARD_AUTORECONF = NO
XDRIVER_XF86_INPUT_KEYBOARD_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_kbproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_KEYBOARD_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-keyboard))
