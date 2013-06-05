################################################################################
#
# xapp_xclipboard
#
################################################################################

XAPP_XCLIPBOARD_VERSION = 1.1.2
XAPP_XCLIPBOARD_SOURCE = xclipboard-$(XAPP_XCLIPBOARD_VERSION).tar.bz2
XAPP_XCLIPBOARD_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XCLIPBOARD_LICENSE = MIT
XAPP_XCLIPBOARD_LICENSE_FILES = COPYING
XAPP_XCLIPBOARD_DEPENDENCIES = xlib_libXaw xlib_libXmu xlib_libXt

$(eval $(autotools-package))
