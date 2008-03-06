################################################################################
#
# xapp_fslsfonts -- list fonts served by X font server
#
################################################################################

XAPP_FSLSFONTS_VERSION = 1.0.1
XAPP_FSLSFONTS_SOURCE = fslsfonts-$(XAPP_FSLSFONTS_VERSION).tar.bz2
XAPP_FSLSFONTS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_FSLSFONTS_AUTORECONF = NO
XAPP_FSLSFONTS_DEPENDENCIES = xlib_libFS xlib_libX11

$(eval $(call AUTOTARGETS,package/x11r7,xapp_fslsfonts))
