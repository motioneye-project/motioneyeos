################################################################################
#
# xapp_xsm -- X Session Manager
#
################################################################################

XAPP_XSM_VERSION = 1.0.1
XAPP_XSM_SOURCE = xsm-$(XAPP_XSM_VERSION).tar.bz2
XAPP_XSM_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XSM_AUTORECONF = YES
XAPP_XSM_DEPENDANCIES = xlib_libXaw

$(eval $(call AUTOTARGETS,xapp_xsm))
