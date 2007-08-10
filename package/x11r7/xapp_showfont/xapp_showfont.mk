################################################################################
#
# xapp_showfont -- font dumper for X font server
#
################################################################################

XAPP_SHOWFONT_VERSION = 1.0.1
XAPP_SHOWFONT_SOURCE = showfont-$(XAPP_SHOWFONT_VERSION).tar.bz2
XAPP_SHOWFONT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_SHOWFONT_AUTORECONF = YES
XAPP_SHOWFONT_DEPENDANCIES = xlib_libFS

$(eval $(call AUTOTARGETS,xapp_showfont))
