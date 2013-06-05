################################################################################
#
# xapp_xsm
#
################################################################################

XAPP_XSM_VERSION = 1.0.2
XAPP_XSM_SOURCE = xsm-$(XAPP_XSM_VERSION).tar.bz2
XAPP_XSM_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSM_LICENSE = MIT
XAPP_XSM_LICENSE_FILES = COPYING
XAPP_XSM_DEPENDENCIES = xlib_libXaw

$(eval $(autotools-package))
