################################################################################
#
# xdriver_xf86-input-vmmouse
#
################################################################################

XDRIVER_XF86_INPUT_VMMOUSE_VERSION = 13.0.0
XDRIVER_XF86_INPUT_VMMOUSE_SOURCE = xf86-input-vmmouse-$(XDRIVER_XF86_INPUT_VMMOUSE_VERSION).tar.bz2
XDRIVER_XF86_INPUT_VMMOUSE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_VMMOUSE_LICENSE = MIT
XDRIVER_XF86_INPUT_VMMOUSE_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_VMMOUSE_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(autotools-package))
