################################################################################
#
# xdriver_xf86-input-synaptics
#
################################################################################

XDRIVER_XF86_INPUT_SYNAPTICS_VERSION = 1.9.1
XDRIVER_XF86_INPUT_SYNAPTICS_SOURCE = xf86-input-synaptics-$(XDRIVER_XF86_INPUT_SYNAPTICS_VERSION).tar.bz2
XDRIVER_XF86_INPUT_SYNAPTICS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_SYNAPTICS_LICENSE = MIT
XDRIVER_XF86_INPUT_SYNAPTICS_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_SYNAPTICS_DEPENDENCIES = libevdev xserver_xorg-server xorgproto mtdev
XDRIVER_XF86_INPUT_SYNAPTICS_AUTORECONF = YES

$(eval $(autotools-package))
