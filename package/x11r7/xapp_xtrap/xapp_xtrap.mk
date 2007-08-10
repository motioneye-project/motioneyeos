################################################################################
#
# xapp_xtrap -- X.Org xtrap application
#
################################################################################

XAPP_XTRAP_VERSION = 1.0.2
XAPP_XTRAP_SOURCE = xtrap-$(XAPP_XTRAP_VERSION).tar.bz2
XAPP_XTRAP_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XTRAP_AUTORECONF = YES
XAPP_XTRAP_DEPENDANCIES = xlib_libX11 xlib_libXTrap

$(eval $(call AUTOTARGETS,xapp_xtrap))
