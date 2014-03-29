################################################################################
#
# xapp_fstobdf
#
################################################################################

XAPP_FSTOBDF_VERSION = 1.0.5
XAPP_FSTOBDF_SOURCE = fstobdf-$(XAPP_FSTOBDF_VERSION).tar.bz2
XAPP_FSTOBDF_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_FSTOBDF_LICENSE = MIT
XAPP_FSTOBDF_LICENSE_FILES = COPYING
XAPP_FSTOBDF_DEPENDENCIES = xlib_libFS xlib_libX11

$(eval $(autotools-package))
