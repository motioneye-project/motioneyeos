################################################################################
#
# xdriver_xf86-input-mouse
#
################################################################################

XDRIVER_XF86_INPUT_MOUSE_VERSION = 1.7.2
XDRIVER_XF86_INPUT_MOUSE_SOURCE = xf86-input-mouse-$(XDRIVER_XF86_INPUT_MOUSE_VERSION).tar.bz2
XDRIVER_XF86_INPUT_MOUSE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_MOUSE_LICENSE = MIT
XDRIVER_XF86_INPUT_MOUSE_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_MOUSE_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(autotools-package))
