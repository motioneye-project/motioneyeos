################################################################################
#
# xdriver_xf86-input-void
#
################################################################################

XDRIVER_XF86_INPUT_VOID_VERSION = 1.4.1
XDRIVER_XF86_INPUT_VOID_SOURCE = xf86-input-void-$(XDRIVER_XF86_INPUT_VOID_VERSION).tar.bz2
XDRIVER_XF86_INPUT_VOID_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_VOID_LICENSE = MIT
XDRIVER_XF86_INPUT_VOID_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_VOID_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto

$(eval $(autotools-package))
