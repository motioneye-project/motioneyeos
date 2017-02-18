################################################################################
#
# xdriver_xf86-input-joystick
#
################################################################################

XDRIVER_XF86_INPUT_JOYSTICK_VERSION = 1.6.2
XDRIVER_XF86_INPUT_JOYSTICK_SOURCE = xf86-input-joystick-$(XDRIVER_XF86_INPUT_JOYSTICK_VERSION).tar.bz2
XDRIVER_XF86_INPUT_JOYSTICK_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_JOYSTICK_LICENSE = MIT
XDRIVER_XF86_INPUT_JOYSTICK_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_JOYSTICK_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

define XDRIVER_XF86_INPUT_JOYSTICK_CONF
	$(INSTALL) -m 0644 -D \
		$(XDRIVER_XF86_INPUT_JOYSTICK_PKGDIR)/50-joystick.conf \
		$(TARGET_DIR)/usr/share/X11/xorg.conf.d/50-joystick.conf
endef
XDRIVER_XF86_INPUT_JOYSTICK_POST_INSTALL_TARGET_HOOKS += XDRIVER_XF86_INPUT_JOYSTICK_CONF

$(eval $(autotools-package))
