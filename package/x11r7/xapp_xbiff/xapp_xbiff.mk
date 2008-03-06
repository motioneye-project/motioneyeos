################################################################################
#
# xapp_xbiff -- mailbox flag for X
#
################################################################################

XAPP_XBIFF_VERSION = 1.0.1
XAPP_XBIFF_SOURCE = xbiff-$(XAPP_XBIFF_VERSION).tar.bz2
XAPP_XBIFF_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XBIFF_AUTORECONF = NO
XAPP_XBIFF_DEPENDENCIES = xlib_libXaw xdata_xbitmaps

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xbiff))
