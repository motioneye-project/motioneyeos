################################################################################
#
# xdata_xkbdata -- No description available
#
################################################################################

XDATA_XKBDATA_VERSION = 1.0.1
XDATA_XKBDATA_SOURCE = xkbdata-$(XDATA_XBITMAPS_VERSION).tar.bz2
XDATA_XKBDATA_SITE = http://xorg.freedesktop.org/releases/individual/data
XDATA_XKBDATA_AUTORECONF = NO
XDATA_XKBDATA_INSTALL_STAGING = YES
XDATA_XKBDATA_INSTALL_TARGET = YES
XDATA_XKBDATA_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install
XDATA_XKBDATA_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdata_xkbdata))
