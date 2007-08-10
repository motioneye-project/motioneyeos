################################################################################
#
# xapp_xgc -- X graphics demo
#
################################################################################

XAPP_XGC_VERSION = 1.0.1
XAPP_XGC_SOURCE = xgc-$(XAPP_XGC_VERSION).tar.bz2
XAPP_XGC_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XGC_AUTORECONF = YES
XAPP_XGC_DEPENDANCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,xapp_xgc))
