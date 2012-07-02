################################################################################
#
# xdata_xbitmaps -- No description available
#
################################################################################

XDATA_XBITMAPS_VERSION = 1.1.0
XDATA_XBITMAPS_SOURCE = xbitmaps-$(XDATA_XBITMAPS_VERSION).tar.bz2
XDATA_XBITMAPS_SITE = http://xorg.freedesktop.org/releases/individual/data
XDATA_XBITMAPS_INSTALL_STAGING = YES

$(eval $(autotools-package))
