################################################################################
#
# xapp_xlsclients -- X.Org xlsclients application
#
################################################################################

XAPP_XLSCLIENTS_VERSION = 1.0.1
XAPP_XLSCLIENTS_SOURCE = xlsclients-$(XAPP_XLSCLIENTS_VERSION).tar.bz2
XAPP_XLSCLIENTS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XLSCLIENTS_AUTORECONF = YES
XAPP_XLSCLIENTS_DEPENDANCIES = xlib_libX11 xlib_libXmu

$(eval $(call AUTOTARGETS,xapp_xlsclients))
