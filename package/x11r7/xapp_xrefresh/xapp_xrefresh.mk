################################################################################
#
# xapp_xrefresh -- refresh all or part of an X screen
#
################################################################################

XAPP_XREFRESH_VERSION = 1.0.2
XAPP_XREFRESH_SOURCE = xrefresh-$(XAPP_XREFRESH_VERSION).tar.bz2
XAPP_XREFRESH_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XREFRESH_AUTORECONF = YES
XAPP_XREFRESH_DEPENDENCIES = xlib_libX11

$(eval $(call AUTOTARGETS,xapp_xrefresh))
