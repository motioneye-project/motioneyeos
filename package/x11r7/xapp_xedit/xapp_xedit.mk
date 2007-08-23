################################################################################
#
# xapp_xedit -- simple text editor for X
#
################################################################################

XAPP_XEDIT_VERSION = 1.0.2
XAPP_XEDIT_SOURCE = xedit-$(XAPP_XEDIT_VERSION).tar.bz2
XAPP_XEDIT_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XEDIT_AUTORECONF = YES
XAPP_XEDIT_DEPENDENCIES = xlib_libXaw xlib_libXprintUtil

$(eval $(call AUTOTARGETS,xapp_xedit))
