################################################################################
#
# xapp_fslsfonts
#
################################################################################

XAPP_FSLSFONTS_VERSION = 1.0.4
XAPP_FSLSFONTS_SOURCE = fslsfonts-$(XAPP_FSLSFONTS_VERSION).tar.bz2
XAPP_FSLSFONTS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_FSLSFONTS_LICENSE = MIT
XAPP_FSLSFONTS_LICENSE_FILES = COPYING
XAPP_FSLSFONTS_DEPENDENCIES = xlib_libFS xlib_libX11

$(eval $(autotools-package))
