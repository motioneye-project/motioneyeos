################################################################################
#
# xapp_fstobdf -- generate BDF font from X font server
#
################################################################################

XAPP_FSTOBDF_VERSION = 1.0.2
XAPP_FSTOBDF_SOURCE = fstobdf-$(XAPP_FSTOBDF_VERSION).tar.bz2
XAPP_FSTOBDF_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_FSTOBDF_AUTORECONF = YES
XAPP_FSTOBDF_DEPENDANCIES = xlib_libFS xlib_libX11

$(eval $(call AUTOTARGETS,xapp_fstobdf))
