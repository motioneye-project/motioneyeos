################################################################################
#
# xapp_bdftopcf -- X.Org bdftopcf application
#
################################################################################

XAPP_BDFTOPCF_VERSION = 1.0.2
XAPP_BDFTOPCF_SOURCE = bdftopcf-$(XAPP_BDFTOPCF_VERSION).tar.bz2
XAPP_BDFTOPCF_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_BDFTOPCF_DEPENDENCIES = xlib_libXfont

$(eval $(autotools-package))
$(eval $(host-autotools-package))
