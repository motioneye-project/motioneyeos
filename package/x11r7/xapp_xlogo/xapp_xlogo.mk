################################################################################
#
# xapp_xlogo
#
################################################################################

XAPP_XLOGO_VERSION = 1.0.4
XAPP_XLOGO_SOURCE = xlogo-$(XAPP_XLOGO_VERSION).tar.bz2
XAPP_XLOGO_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XLOGO_LICENSE = MIT
XAPP_XLOGO_LICENSE_FILES = COPYING
XAPP_XLOGO_DEPENDENCIES = xlib_libXaw xlib_libXrender \
			  xlib_libXft host-pkgconf

$(eval $(autotools-package))
