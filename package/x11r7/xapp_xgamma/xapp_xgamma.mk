################################################################################
#
# xapp_xgamma -- Alter a monitor's gamma correction through the X server
#
################################################################################

XAPP_XGAMMA_VERSION = 1.0.2
XAPP_XGAMMA_SOURCE = xgamma-$(XAPP_XGAMMA_VERSION).tar.bz2
XAPP_XGAMMA_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XGAMMA_AUTORECONF = NO
XAPP_XGAMMA_DEPENDENCIES = xlib_libXxf86vm

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xgamma))
