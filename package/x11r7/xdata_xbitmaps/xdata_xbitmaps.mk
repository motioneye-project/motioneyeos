################################################################################
#
# xdata_xbitmaps -- No description available
#
################################################################################

XDATA_XBITMAPS_VERSION = 1.0.1
XDATA_XBITMAPS_SOURCE = xbitmaps-$(XDATA_XBITMAPS_VERSION).tar.bz2
XDATA_XBITMAPS_SITE = http://xorg.freedesktop.org/releases/individual/data
XDATA_XBITMAPS_AUTORECONF = NO
XDATA_XBITMAPS_INSTALL_STAGING = YES
XDATA_XBITMAPS_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package/x11r7,xdata_xbitmaps))
