################################################################################
#
# xdriver_xf86-input-libinput
#
################################################################################

XDRIVER_XF86_INPUT_LIBINPUT_VERSION = 0.19.0
XDRIVER_XF86_INPUT_LIBINPUT_SOURCE = xf86-input-libinput-$(XDRIVER_XF86_INPUT_LIBINPUT_VERSION).tar.bz2
XDRIVER_XF86_INPUT_LIBINPUT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_LIBINPUT_LICENSE = MIT
XDRIVER_XF86_INPUT_LIBINPUT_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_LIBINPUT_DEPENDENCIES = libinput xserver_xorg-server xproto_inputproto xproto_xproto

$(eval $(autotools-package))
